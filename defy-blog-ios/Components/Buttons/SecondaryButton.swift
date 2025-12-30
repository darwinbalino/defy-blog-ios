//
//  SecondaryButton.swift
//  DefyBlog
//
//  Secondary grey button component matching design system
//

import SwiftUI

struct SecondaryButton: View {
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
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(title)
                        .font(.system(size: Constants.Typography.body, weight: .medium))
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: Constants.UI.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .fill(isDisabled ? AppColors.secondaryBackground.opacity(0.5) : AppColors.buttonSecondary)
            )
        }
        .disabled(isDisabled || isLoading)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}

// MARK: - Preview
struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            SecondaryButton(title: "Cancel", action: {})
            
            SecondaryButton(title: "Settings", action: {}, icon: "gearshape.fill")
            
            SecondaryButton(title: "Loading...", action: {}, isLoading: true)
            
            SecondaryButton(title: "Disabled", action: {}, isDisabled: true)
        }
        .padding()
        .background(AppColors.primaryBackground)
        .previewLayout(.sizeThatFits)
    }
}
