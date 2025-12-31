//
//  SignUpView.swift
//  DefyBlog
//
//  Sign up screen for email/password registration
//

import SwiftUI

struct SignUpView: View {
    // MARK: - Properties
    @StateObject private var viewModel = AuthenticationViewModel()
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Body
    var body: some View {
        ZStack {
            AppColors.primaryBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: Constants.UI.largeSpacing) {
                    // Header
                    headerSection
                    
                    // Form
                    formSection
                    
                    // Sign Up Button
                    PrimaryButton(
                        title: "Create Account",
                        action: {
                            Task {
                                await viewModel.registerWithEmail()
                            }
                        },
                        isLoading: viewModel.isLoading
                    )
                    
                    // Sign In Link
                    signInSection
                }
                .padding(Constants.UI.screenPadding)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: Constants.Typography.body, weight: .regular))
                    }
                    .foregroundColor(AppColors.primaryText)
                }
            }
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? Constants.ErrorMessages.genericError)
        }
        .onChange(of: viewModel.isAuthenticated) { _, newValue in
            if newValue {
                dismiss()
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: Constants.UI.mediumSpacing) {
            Text("Create Account")
                .font(.system(size: Constants.Typography.largeTitle, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Join Defy.Blog to start reading")
                .font(.system(size: Constants.Typography.body))
                .foregroundColor(AppColors.secondaryText)
        }
        .padding(.top, Constants.UI.largeSpacing)
        .padding(.bottom, Constants.UI.mediumSpacing)
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: Constants.UI.mediumSpacing) {
            CustomTextField(
                placeholder: "Display Name",
                text: $viewModel.displayName,
                autocapitalization: .words,
                icon: "person"
            )
            
            CustomTextField(
                placeholder: "Email",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                icon: "envelope"
            )
            
            CustomTextField(
                placeholder: "Password",
                text: $viewModel.password,
                isSecure: true,
                icon: "lock"
            )
            
            CustomTextField(
                placeholder: "Confirm Password",
                text: $viewModel.confirmPassword,
                isSecure: true,
                icon: "lock"
            )
            
            // Password Requirements
            passwordRequirementsSection
        }
    }
    
    // MARK: - Password Requirements Section
    private var passwordRequirementsSection: some View {
        VStack(alignment: .leading, spacing: Constants.UI.smallSpacing) {
            Text("Password must:")
                .font(.system(size: Constants.Typography.caption, weight: .medium))
                .foregroundColor(AppColors.secondaryText)
            
            RequirementRow(
                text: "Be at least \(Constants.Validation.minPasswordLength) characters",
                isMet: viewModel.password.count >= Constants.Validation.minPasswordLength
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Constants.UI.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(AppColors.cardBackground.opacity(0.5))
        )
    }
    
    // MARK: - Sign In Section
    private var signInSection: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .font(.system(size: Constants.Typography.body))
                .foregroundColor(AppColors.secondaryText)
            
            Button(action: {
                dismiss()
            }) {
                Text("Sign In")
                    .font(.system(size: Constants.Typography.body, weight: .semibold))
                    .foregroundColor(AppColors.primaryBlue)
            }
        }
        .padding(.top, Constants.UI.smallSpacing)
    }
}

// MARK: - Requirement Row Component
struct RequirementRow: View {
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: Constants.UI.smallSpacing) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 12))
                .foregroundColor(isMet ? AppColors.success : AppColors.secondaryText)
            
            Text(text)
                .font(.system(size: Constants.Typography.caption))
                .foregroundColor(isMet ? AppColors.primaryText : AppColors.secondaryText)
        }
    }
}

// MARK: - Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignUpView()
        }
    }
}
