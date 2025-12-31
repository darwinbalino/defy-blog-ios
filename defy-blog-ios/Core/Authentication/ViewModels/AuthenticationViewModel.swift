//
//  AuthenticationViewModel.swift
//  DefyBlog
//
//  ViewModel managing authentication state and operations
//

import Foundation
import SwiftUI
import FirebaseAuth
import AuthenticationServices
import Combine


@MainActor
class AuthenticationViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var displayName: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false
    @Published var isAuthenticated: Bool = false
    
    // MARK: - Services
    private let authService = AuthenticationService()
    private let userService = UserService.shared
    
    // MARK: - Initialization
    init() {
        observeAuthState()
    }
    
    // MARK: - Auth State Observation
    
    private func observeAuthState() {
        authService.$authState
            .map { $0 == .authenticated }
            .assign(to: &$isAuthenticated)
    }
    
    // MARK: - Google Sign-In
    
    func signInWithGoogle() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let firebaseUser = try await authService.signInWithGoogle()
            try await handleSuccessfulSignIn(firebaseUser: firebaseUser)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Apple Sign-In
    
    func signInWithApple(authorization: ASAuthorization) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let firebaseUser = try await authService.signInWithApple(authorization: authorization)
            try await handleSuccessfulSignIn(firebaseUser: firebaseUser)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Email/Password Sign-In
    
    func signInWithEmail() async {
        guard validateSignInInputs() else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let firebaseUser = try await authService.signInWithEmail(
                email: email.trimmingCharacters(in: .whitespaces),
                password: password
            )
            try await handleSuccessfulSignIn(firebaseUser: firebaseUser)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Email/Password Registration
    
    func registerWithEmail() async {
        guard validateRegistrationInputs() else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let firebaseUser = try await authService.registerWithEmail(
                email: email.trimmingCharacters(in: .whitespaces),
                password: password,
                displayName: displayName.trimmingCharacters(in: .whitespaces)
            )
            
            // Create user document in Firestore
            let newUser = User(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? "",
                displayName: firebaseUser.displayName ?? displayName,
                photoURL: firebaseUser.photoURL?.absoluteString
            )
            
            try await userService.createUser(newUser)
            try await handleSuccessfulSignIn(firebaseUser: firebaseUser)
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Password Reset
    
    func sendPasswordReset() async {
        guard !email.isEmpty else {
            showErrorMessage(Constants.ErrorMessages.invalidEmail)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.sendPasswordReset(email: email.trimmingCharacters(in: .whitespaces))
            showErrorMessage("Password reset email sent. Please check your inbox.")
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        do {
            try authService.signOut()
            clearForm()
        } catch {
            handleError(error)
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleSuccessfulSignIn(firebaseUser: FirebaseAuth.User) async throws {
        // Check if user document exists, create if not
        let userExists = try await userService.userExists(id: firebaseUser.uid)
        
        if !userExists {
            let newUser = User(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? "",
                displayName: firebaseUser.displayName ?? "User",
                photoURL: firebaseUser.photoURL?.absoluteString
            )
            try await userService.createUser(newUser)
        }
        
        clearForm()
    }
    
    private func validateSignInInputs() -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedEmail.isEmpty else {
            showErrorMessage("Please enter your email")
            return false
        }
        
        guard !password.isEmpty else {
            showErrorMessage("Please enter your password")
            return false
        }
        
        return true
    }
    
    private func validateRegistrationInputs() -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)
        let trimmedDisplayName = displayName.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedEmail.isEmpty else {
            showErrorMessage("Please enter your email")
            return false
        }
        
        guard !trimmedDisplayName.isEmpty else {
            showErrorMessage("Please enter your name")
            return false
        }
        
        guard password.count >= Constants.Validation.minPasswordLength else {
            showErrorMessage(Constants.ErrorMessages.invalidPassword)
            return false
        }
        
        guard password == confirmPassword else {
            showErrorMessage(Constants.ErrorMessages.passwordMismatch)
            return false
        }
        
        return true
    }
    
    private func handleError(_ error: Error) {
        if let authError = error as? AuthenticationService.AuthError {
            showErrorMessage(authError.errorDescription ?? Constants.ErrorMessages.genericError)
        } else if let nsError = error as NSError? {
            // Handle Firebase Auth errors
            switch nsError.code {
            case AuthErrorCode.emailAlreadyInUse.rawValue:
                showErrorMessage(Constants.ErrorMessages.emailAlreadyInUse)
            case AuthErrorCode.userNotFound.rawValue:
                showErrorMessage(Constants.ErrorMessages.userNotFound)
            case AuthErrorCode.wrongPassword.rawValue:
                showErrorMessage("Incorrect password")
            case AuthErrorCode.networkError.rawValue:
                showErrorMessage(Constants.ErrorMessages.networkError)
            default:
                showErrorMessage(nsError.localizedDescription)
            }
        } else {
            showErrorMessage(error.localizedDescription)
        }
    }
    
    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
    
    private func clearForm() {
        email = ""
        password = ""
        confirmPassword = ""
        displayName = ""
        errorMessage = nil
        showError = false
    }
}
