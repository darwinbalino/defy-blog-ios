//
//  DefyBlogApp.swift
//  DefyBlog
//
//  Main app entry point with Firebase configuration
//

import SwiftUI
import FirebaseCore
import Firebase
import FirebaseAnalytics
import FirebaseCrashlytics
import GoogleSignIn

@main
struct DefyBlogApp: App {
    // MARK: - Properties
    @StateObject private var authService = AuthenticationService()
    
    // MARK: - Initialization
    init() {
        configureFirebase()
        configureAppearance()
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
    
    // MARK: - Configuration
    
    /// Configure Firebase
    private func configureFirebase() {
        FirebaseApp.configure()
        
        // Configure Analytics
        Analytics.setAnalyticsCollectionEnabled(true)
        
        // Configure Crashlytics
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        // Optional: Set user properties for analytics
        // Analytics.setUserProperty("app_version", forName: "version")
        
        // Optional: Enable Firestore offline persistence
//        let settings = FirestoreSettings()
//        settings.isPersistenceEnabled = true
//        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
//        Firestore.firestore().settings = settings
    }
    
    /// Configure app-wide appearance
    private func configureAppearance() {
        // Navigation Bar Appearance
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(AppColors.primaryBackground)
        navigationBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primaryText),
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        navigationBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor(AppColors.primaryText),
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Tab Bar Appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(AppColors.secondaryBackground)
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Set tint colors
        UINavigationBar.appearance().tintColor = UIColor(AppColors.primaryText)
        UITabBar.appearance().tintColor = UIColor(AppColors.primaryBlue)
        UITabBar.appearance().unselectedItemTintColor = UIColor(AppColors.secondaryText)
    }
}
