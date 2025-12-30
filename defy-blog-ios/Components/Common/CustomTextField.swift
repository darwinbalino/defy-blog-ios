//
//  CustomTextField.swift
//  DefyBlog
//
//  Styled text field component matching design system
//

import SwiftUI

struct CustomTextField: View {
    // MARK: - Properties
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .never
    var icon: String? = nil
    
    @State private var isSecureVisible: Bool = false
    
    // MARK: - Body
    var body: some View {
        HStack(spacing: Constants.UI.smallSpacing) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(AppColors.secondaryText)
                    .frame(width: 20)
            }
            
            if isSecure && !isSecureVisible {
                SecureField(placeholder, text: $text)
                    .textFieldStyle()
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textInputAutocapitalization(autocapitalization)
                    .textFieldStyle()
            }
            
            if isSecure {
                Button(action: { isSecureVisible.toggle() }) {
                    Image(systemName: isSecureVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(AppColors.secondaryText)
                }
            }
        }
        .padding(Constants.UI.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .fill(AppColors.inputBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(AppColors.secondaryText.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - TextField Style Extension
extension View {
    func textFieldStyle() -> some View {
        self
            .font(.system(size: Constants.Typography.body))
            .foregroundColor(AppColors.primaryText)
            .autocorrectionDisabled()
    }
}

// MARK: - Preview
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CustomTextField(
                placeholder: "Email",
                text: .constant(""),
                keyboardType: .emailAddress,
                icon: "envelope"
            )
            
            CustomTextField(
                placeholder: "Password",
                text: .constant(""),
                isSecure: true,
                icon: "lock"
            )
            
            CustomTextField(
                placeholder: "Display Name",
                text: .constant(""),
                autocapitalization: .words,
                icon: "person"
            )
        }
        .padding()
        .background(AppColors.primaryBackground)
        .previewLayout(.sizeThatFits)
    }
}
