//
//  Constants.swift
//  DefyBlog
//
//  App-wide constants and configuration values
//

import Foundation

struct Constants {
    // MARK: - App Info
    struct App {
        static let name = "Defy.Blog"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    // MARK: - Firebase Collections
    struct Collections {
        static let users = "users"
        static let topics = "topics"
        static let publications = "publications"
        static let articles = "articles"
        static let readingProgress = "readingProgress"
    }
    
    // MARK: - UI Constants
    struct UI {
        // Corner Radius
        static let cornerRadius: CGFloat = 12
        static let smallCornerRadius: CGFloat = 8
        
        // Spacing
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 24
        
        // Button Dimensions
        static let buttonHeight: CGFloat = 52
        static let smallButtonHeight: CGFloat = 44
        
        // Padding
        static let screenPadding: CGFloat = 20
        static let cardPadding: CGFloat = 16
    }
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle: CGFloat = 34
        static let title1: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subheadline: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption: CGFloat = 12
    }
    
    // MARK: - Animation
    struct Animation {
        static let standard: Double = 0.3
        static let quick: Double = 0.2
        static let slow: Double = 0.5
    }
    
    // MARK: - Validation
    struct Validation {
        static let minPasswordLength = 8
        static let maxPasswordLength = 128
        static let maxDisplayNameLength = 50
        
        // Email regex pattern
        static let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    // MARK: - Limits
    struct Limits {
        static let maxBookmarks = 1000
        static let maxFollowedTopics = 20
        static let maxFollowedPublications = 100
        static let articlesPerPage = 20
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let genericError = "Something went wrong. Please try again."
        static let networkError = "Network connection failed. Please check your internet connection."
        static let authenticationError = "Authentication failed. Please try again."
        static let invalidEmail = "Please enter a valid email address."
        static let invalidPassword = "Password must be at least \(Validation.minPasswordLength) characters."
        static let passwordMismatch = "Passwords do not match."
        static let userNotFound = "User not found."
        static let emailAlreadyInUse = "This email is already registered."
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaultsKeys {
        static let hasSeenOnboarding = "hasSeenOnboarding"
        static let lastSyncDate = "lastSyncDate"
        static let preferredReadingMode = "preferredReadingMode"
    }
}
