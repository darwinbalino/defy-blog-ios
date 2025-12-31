//
//  AuthenticationService.swift
//  DefyBlog
//
//  Service handling all authentication operations (Google, Apple, Email/Password)
//

import Foundation
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices
import CryptoKit
import Combine

@MainActor
class AuthenticationService: ObservableObject {
    // MARK: - Properties
    @Published var currentUser: FirebaseAuth.User?
    @Published var authState: AuthState = .unauthenticated
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    
    enum AuthState {
        case authenticated
        case unauthenticated
        case loading
    }
    
    // MARK: - Initialization
    init() {
        registerAuthStateHandler()
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Auth State Listening
    
    /// Register listener for authentication state changes
    private func registerAuthStateHandler() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.currentUser = user
            self?.authState = user != nil ? .authenticated : .unauthenticated
        }
    }
    
    // MARK: - Google Sign-In
    
    /// Sign in with Google
    func signInWithGoogle() async throws -> FirebaseAuth.User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.configurationError
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            throw AuthError.noRootViewController
        }
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.tokenError
        }
        
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
        )
        
        let authResult = try await Auth.auth().signIn(with: credential)
        return authResult.user
    }
    
    // MARK: - Apple Sign-In
    
    /// Sign in with Apple
    func signInWithApple(authorization: ASAuthorization) async throws -> FirebaseAuth.User {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            throw AuthError.invalidCredential
        }
        
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw AuthError.tokenError
        }
        
        let nonce = randomNonceString()
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        let authResult = try await Auth.auth().signIn(with: credential)
        return authResult.user
    }
    
    // MARK: - Email/Password Authentication
    
    /// Register new user with email and password
    func registerWithEmail(
        email: String,
        password: String,
        displayName: String
    ) async throws -> FirebaseAuth.User {
        // Validate inputs
        try validateEmail(email)
        try validatePassword(password)
        try validateDisplayName(displayName)
        
        // Create user
        let authResult = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )
        
        // Update profile with display name
        let changeRequest = authResult.user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
        
        // Send verification email
        try await authResult.user.sendEmailVerification()
        
        return authResult.user
    }
    
    /// Sign in with email and password
    func signInWithEmail(email: String, password: String) async throws -> FirebaseAuth.User {
        try validateEmail(email)
        try validatePassword(password)
        
        let authResult = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )
        
        return authResult.user
    }
    
    /// Send password reset email
    func sendPasswordReset(email: String) async throws {
        try validateEmail(email)
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    /// Update password for current user
    func updatePassword(newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noCurrentUser
        }
        
        try validatePassword(newPassword)
        try await user.updatePassword(to: newPassword)
    }
    
    /// Update display name for current user
    func updateDisplayName(_ displayName: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noCurrentUser
        }
        
        try validateDisplayName(displayName)
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
    }
    
    // MARK: - Sign Out
    
    /// Sign out current user
    func signOut() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }
    
    // MARK: - Delete Account
    
    /// Delete current user account
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noCurrentUser
        }
        
        try await user.delete()
    }
    
    // MARK: - Helper Methods
    
    /// Validate email format
    private func validateEmail(_ email: String) throws {
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", Constants.Validation.emailPattern)
        guard emailPredicate.evaluate(with: email) else {
            throw AuthError.invalidEmail
        }
    }
    
    /// Validate password strength
    private func validatePassword(_ password: String) throws {
        guard password.count >= Constants.Validation.minPasswordLength else {
            throw AuthError.weakPassword
        }
        guard password.count <= Constants.Validation.maxPasswordLength else {
            throw AuthError.passwordTooLong
        }
    }
    
    /// Validate display name
    private func validateDisplayName(_ displayName: String) throws {
        guard !displayName.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw AuthError.emptyDisplayName
        }
        guard displayName.count <= Constants.Validation.maxDisplayNameLength else {
            throw AuthError.displayNameTooLong
        }
    }
    
    /// Generate random nonce for Apple Sign-In
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
}

// MARK: - Auth Errors
extension AuthenticationService {
    enum AuthError: LocalizedError {
        case configurationError
        case noRootViewController
        case tokenError
        case invalidCredential
        case noCurrentUser
        case invalidEmail
        case weakPassword
        case passwordTooLong
        case emptyDisplayName
        case displayNameTooLong
        case emailAlreadyInUse
        case userNotFound
        case wrongPassword
        case networkError
        case unknown(Error)
        
        nonisolated var errorDescription: String? {
            switch self {
            case .configurationError:
                return "App configuration error. Please contact support."
            case .noRootViewController:
                return "Unable to present sign-in interface."
            case .tokenError:
                return "Authentication token error."
            case .invalidCredential:
                return "Invalid credentials provided."
            case .noCurrentUser:
                return "No user is currently signed in."
            case .invalidEmail:
                return "Please enter a valid email address."
            case .weakPassword:
                return "Password must be at least 8 characters."
            case .passwordTooLong:
                return "Password is too long."
            case .emptyDisplayName:
                return "Display name cannot be empty."
            case .displayNameTooLong:
                return "Display name is too long."
            case .emailAlreadyInUse:
                return "This email is already registered."
            case .userNotFound:
                return "User not found."
            case .wrongPassword:
                return "Incorrect password."
            case .networkError:
                return "Network connection failed. Please check your internet connection."
            case .unknown(let error):
                return error.localizedDescription
            }
        }
    }
}
