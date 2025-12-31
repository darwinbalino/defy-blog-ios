//
//  UserService.swift
//  DefyBlog
//
//  Service for user-related Firestore operations
//

import Foundation
import FirebaseFirestore

class UserService: FirestoreService {
    // MARK: - Singleton
    static let shared = UserService()
    
    private override init() {
        super.init()
    }
    
    // MARK: - User Operations
    
    /// Create new user document in Firestore
    func createUser(_ user: User) async throws {
        _ = try await create(
            user,
            in: Constants.Collections.users,
            documentId: user.id
        )
    }
    
    /// Fetch user by ID
    func fetchUser(id: String) async throws -> User? {
        return try await read(
            from: Constants.Collections.users,
            documentId: id,
            as: User.self
        )
    }
    
    /// Update user data
    func updateUser(id: String, data: [String: Any]) async throws {
        try await update(
            in: Constants.Collections.users,
            documentId: id,
            data: data
        )
    }
    
    /// Delete user
    func deleteUser(id: String) async throws {
        try await delete(
            from: Constants.Collections.users,
            documentId: id
        )
    }
    
    /// Check if user document exists
    func userExists(id: String) async throws -> Bool {
        return try await exists(
            in: Constants.Collections.users,
            documentId: id
        )
    }
    
    // MARK: - User Profile Updates
    
    /// Update user's display name
    func updateDisplayName(userId: String, displayName: String) async throws {
        try await updateUser(id: userId, data: ["displayName": displayName])
    }
    
    /// Update user's photo URL
    func updatePhotoURL(userId: String, photoURL: String) async throws {
        try await updateUser(id: userId, data: ["photoURL": photoURL])
    }
    
    /// Update user's email
    func updateEmail(userId: String, email: String) async throws {
        try await updateUser(id: userId, data: ["email": email])
    }
    
    // MARK: - Onboarding
    
    /// Mark onboarding as completed
    func completeOnboarding(userId: String) async throws {
        try await updateUser(id: userId, data: ["onboardingCompleted": true])
    }
    
    // MARK: - Topics Management
    
    /// Follow a topic
    func followTopic(userId: String, topicId: String) async throws {
        try await db.collection(Constants.Collections.users)
            .document(userId)
            .updateData([
                "followedTopics": FieldValue.arrayUnion([topicId])
            ])
    }
    
    /// Unfollow a topic
    func unfollowTopic(userId: String, topicId: String) async throws {
        try await db.collection(Constants.Collections.users)
            .document(userId)
            .updateData([
                "followedTopics": FieldValue.arrayRemove([topicId])
            ])
    }
    
    /// Set followed topics (batch update)
    func setFollowedTopics(userId: String, topicIds: [String]) async throws {
        try await updateUser(id: userId, data: ["followedTopics": topicIds])
    }
    
    // MARK: - Publications Management
    
    /// Follow a publication
    func followPublication(userId: String, publicationId: String) async throws {
        try await db.collection(Constants.Collections.users)
            .document(userId)
            .updateData([
                "followedPublications": FieldValue.arrayUnion([publicationId])
            ])
    }
    
    /// Unfollow a publication
    func unfollowPublication(userId: String, publicationId: String) async throws {
        try await db.collection(Constants.Collections.users)
            .document(userId)
            .updateData([
                "followedPublications": FieldValue.arrayRemove([publicationId])
            ])
    }
    
    /// Set followed publications (batch update)
    func setFollowedPublications(userId: String, publicationIds: [String]) async throws {
        try await updateUser(id: userId, data: ["followedPublications": publicationIds])
    }
    
    // MARK: - Bookmarks Management
    
    /// Add bookmark
    func addBookmark(userId: String, articleId: String) async throws {
        try await db.collection(Constants.Collections.users)
            .document(userId)
            .updateData([
                "bookmarks": FieldValue.arrayUnion([articleId])
            ])
    }
    
    /// Remove bookmark
    func removeBookmark(userId: String, articleId: String) async throws {
        try await db.collection(Constants.Collections.users)
            .document(userId)
            .updateData([
                "bookmarks": FieldValue.arrayRemove([articleId])
            ])
    }
    
    /// Check if article is bookmarked
    func isBookmarked(userId: String, articleId: String) async throws -> Bool {
        guard let user = try await fetchUser(id: userId) else {
            return false
        }
        return user.bookmarks.contains(articleId)
    }
    
    // MARK: - Reading Progress
    
    /// Save reading progress
    func saveReadingProgress(
        userId: String,
        articleId: String,
        progress: ReadingProgress
    ) async throws {
        let progressRef = db.collection(Constants.Collections.users)
            .document(userId)
            .collection(Constants.Collections.readingProgress)
            .document(articleId)
        
        try progressRef.setData(from: progress)
    }
    
    /// Fetch reading progress for article
    func fetchReadingProgress(
        userId: String,
        articleId: String
    ) async throws -> ReadingProgress? {
        let snapshot = try await db.collection(Constants.Collections.users)
            .document(userId)
            .collection(Constants.Collections.readingProgress)
            .document(articleId)
            .getDocument()
        
        guard snapshot.exists else { return nil }
        return try snapshot.data(as: ReadingProgress.self)
    }
    
    /// Fetch all reading progress for user
    func fetchAllReadingProgress(userId: String) async throws -> [ReadingProgress] {
        let snapshot = try await db.collection(Constants.Collections.users)
            .document(userId)
            .collection(Constants.Collections.readingProgress)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: ReadingProgress.self) }
    }
}
