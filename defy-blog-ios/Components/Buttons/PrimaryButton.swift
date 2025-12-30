//
//  PrimaryButton.swift
//  DefyBlog
//
//  Primary white button component matching design system
//

import SwiftUI

struct PrimaryButton: View {
    // MARK: - Properties
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    var icon: String? = nil
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(spacing: Constants.UI.smallSpacing) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                } else {
                    Text(title)
                        .font(.system(size: Constants.Typography.body, weight: .medium))
                }
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .frame(height: Constants.UI.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .fill(isDisabled ? AppColors.secondaryText.opacity(0.5) : AppColors.buttonPrimary)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

// MARK: - Preview
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            PrimaryButton(title: "Continue", action: {})
            
            PrimaryButton(title: "Sign In", action: {}, icon: "person.fill")
            
            PrimaryButton(title: "Loading...", action: {}, isLoading: true)
            
            PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
        }
        .padding()
        .background(AppColors.primaryBackground)
        .previewLayout(.sizeThatFits)
    }
}
