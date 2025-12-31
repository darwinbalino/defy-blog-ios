//
//  ContentView.swift
//  DefyBlog
//
//  Root view managing authentication state and navigation
//
import FirebaseAuth
import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @EnvironmentObject var authService: AuthenticationService
    
    // MARK: - Body
    var body: some View {
        Group {
            switch authService.authState {
            case .authenticated:
                // TODO: Replace with MainTabView after onboarding is built
                authenticatedView
                
            case .unauthenticated:
                SignUpView()
                
            case .loading:
                loadingView
            }
        }
        .animation(.easeInOut(duration: Constants.Animation.standard), value: authService.authState)
    }
    
    // MARK: - Authenticated View (Placeholder)
    private var authenticatedView: some View {
        ZStack {
            AppColors.primaryBackground.ignoresSafeArea()
            
            VStack(spacing: Constants.UI.largeSpacing) {
                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(AppColors.success)
                
                VStack(spacing: Constants.UI.smallSpacing) {
                    Text("Authentication Successful!")
                        .font(.system(size: Constants.Typography.title1, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                    
                    Text("You're now signed in")
                        .font(.system(size: Constants.Typography.body))
                        .foregroundColor(AppColors.secondaryText)
                    
                    if let user = authService.currentUser {
                        VStack(spacing: 4) {
                            if let displayName = user.displayName {
                                Text("Welcome, \(displayName)!")
                                    .font(.system(size: Constants.Typography.headline, weight: .medium))
                                    .foregroundColor(AppColors.primaryBlue)
                            }
                            
                            Text(user.email ?? "No email")
                                .font(.system(size: Constants.Typography.subheadline))
                                .foregroundColor(AppColors.secondaryText)
                        }
                        .padding(.top, Constants.UI.mediumSpacing)
                    }
                }
                
                VStack(spacing: Constants.UI.mediumSpacing) {
                    Text("Next Steps:")
                        .font(.system(size: Constants.Typography.headline, weight: .semibold))
                        .foregroundColor(AppColors.primaryText)
                        .padding(.top, Constants.UI.largeSpacing)
                    
                    VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
                        InfoRow(icon: "1.circle.fill", text: "Complete onboarding flow")
                        InfoRow(icon: "2.circle.fill", text: "Build home feed view")
                        InfoRow(icon: "3.circle.fill", text: "Add article reading features")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Constants.UI.cardPadding)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                            .fill(AppColors.cardBackground)
                    )
                }
                .padding(.horizontal, Constants.UI.screenPadding)
                
                Spacer()
                
                // Sign Out Button
                SecondaryButton(
                    title: "Sign Out",
                    action: {
                        try? authService.signOut()
                    },
                    icon: "arrow.right.square"
                )
                .padding(.horizontal, Constants.UI.screenPadding)
                .padding(.bottom, Constants.UI.largeSpacing)
            }
            .padding(.top, Constants.UI.largeSpacing * 2)
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        ZStack {
            AppColors.primaryBackground.ignoresSafeArea()
            
            VStack(spacing: Constants.UI.mediumSpacing) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                
                Text("Loading...")
                    .font(.system(size: Constants.Typography.body))
                    .foregroundColor(AppColors.secondaryText)
            }
        }
    }
}

// MARK: - Info Row Component
struct InfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: Constants.UI.smallSpacing) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.primaryBlue)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: Constants.Typography.body))
                .foregroundColor(AppColors.primaryText)
        }
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationService())
    }
}
