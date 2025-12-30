//
//  User.swift
//  DefyBlog
//
//  Core user model representing authenticated users in the app
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var email: String
    var displayName: String
    var photoURL: String?
    var createdAt: Date
    var onboardingCompleted: Bool
    var followedTopics: [String]
    var followedPublications: [String]
    var bookmarks: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case displayName
        case photoURL
        case createdAt
        case onboardingCompleted
        case followedTopics
        case followedPublications
        case bookmarks
    }
    
    // Initialize new user with defaults
    init(
        id: String,
        email: String,
        displayName: String,
        photoURL: String? = nil,
        createdAt: Date = Date(),
        onboardingCompleted: Bool = false,
        followedTopics: [String] = [],
        followedPublications: [String] = [],
        bookmarks: [String] = []
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.createdAt = createdAt
        self.onboardingCompleted = onboardingCompleted
        self.followedTopics = followedTopics
        self.followedPublications = followedPublications
        self.bookmarks = bookmarks
    }
}

// MARK: - Firestore Conversion
extension User {
    /// Convert User to Firestore dictionary
    var firestoreData: [String: Any] {
        var data: [String: Any] = [
            "email": email,
            "displayName": displayName,
            "createdAt": createdAt,
            "onboardingCompleted": onboardingCompleted,
            "followedTopics": followedTopics,
            "followedPublications": followedPublications,
            "bookmarks": bookmarks
        ]
        
        if let photoURL = photoURL {
            data["photoURL"] = photoURL
        }
        
        return data
    }
    
    /// Initialize User from Firestore dictionary
    init?(id: String, data: [String: Any]) {
        guard
            let email = data["email"] as? String,
            let displayName = data["displayName"] as? String
        else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = data["photoURL"] as? String
        self.createdAt = (data["createdAt"] as? Date) ?? Date()
        self.onboardingCompleted = data["onboardingCompleted"] as? Bool ?? false
        self.followedTopics = data["followedTopics"] as? [String] ?? []
        self.followedPublications = data["followedPublications"] as? [String] ?? []
        self.bookmarks = data["bookmarks"] as? [String] ?? []
    }
}
