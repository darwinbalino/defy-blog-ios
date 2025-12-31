//
//  ForgotPasswordView.swift
//  DefyBlog
//
//  Password reset screen
//

import SwiftUI

struct ForgotPasswordView: View {
    // MARK: - Properties
    @StateObject private var viewModel = AuthenticationViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showSuccessMessage = false
    
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
                    
                    // Reset Button
                    PrimaryButton(
                        title: "Send Reset Link",
                        action: {
                            Task {
                                await viewModel.sendPasswordReset()
                                showSuccessMessage = true
                            }
                        },
                        isLoading: viewModel.isLoading
                    )
                    
                    // Back to Sign In
                    backToSignInSection
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
        .alert("Reset Email Sent", isPresented: $showSuccessMessage) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Check your email for instructions to reset your password.")
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? Constants.ErrorMessages.genericError)
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: Constants.UI.mediumSpacing) {
            // Icon
            Image(systemName: "lock.rotation")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(AppColors.primaryBlue)
                .padding(.bottom, Constants.UI.smallSpacing)
            
            Text("Reset Password")
                .font(.system(size: Constants.Typography.largeTitle, weight: .semibold))
                .foregroundColor(AppColors.primaryText)
            
            Text("Enter your email address and we'll send you a link to reset your password")
                .font(.system(size: Constants.Typography.body))
                .foregroundColor(AppColors.secondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.top, Constants.UI.largeSpacing * 2)
        .padding(.bottom, Constants.UI.mediumSpacing)
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: Constants.UI.mediumSpacing) {
            CustomTextField(
                placeholder: "Email",
                text: $viewModel.email,
                keyboardType: .emailAddress,
                icon: "envelope"
            )
            
            // Info Box
            HStack(alignment: .top, spacing: Constants.UI.smallSpacing) {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.primaryBlue)
                    .padding(.top, 2)
                
                Text("We'll send you an email with instructions to reset your password. Please check your spam folder if you don't see it within a few minutes.")
                    .font(.system(size: Constants.Typography.caption))
                    .foregroundColor(AppColors.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(Constants.UI.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .fill(AppColors.primaryBlue.opacity(0.1))
            )
        }
    }
    
    // MARK: - Back to Sign In Section
    private var backToSignInSection: some View {
        HStack(spacing: 4) {
            Text("Remember your password?")
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

// MARK: - Preview
struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ForgotPasswordView()
        }
    }
}
