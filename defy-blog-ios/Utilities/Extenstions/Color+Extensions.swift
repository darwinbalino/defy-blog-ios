//
//  Color+Extensions.swift
//  DefyBlog
//
//  Convenience extensions for Color
//

import SwiftUI

extension Color {
    // MARK: - App Colors (Quick Access)
    static let appPrimaryBackground = AppColors.primaryBackground
    static let appSecondaryBackground = AppColors.secondaryBackground
    static let appPrimaryText = AppColors.primaryText
    static let appSecondaryText = AppColors.secondaryText
    static let appPrimaryBlue = AppColors.primaryBlue
    static let appLightBlue = AppColors.lightBlue
    static let appCardBackground = AppColors.cardBackground
    static let appInputBackground = AppColors.inputBackground
    static let appButtonPrimary = AppColors.buttonPrimary
    static let appButtonSecondary = AppColors.buttonSecondary
    
    // MARK: - Dynamic Colors
    /// Returns appropriate text color for given background
    static func textColor(for background: Color) -> Color {
        // Simple heuristic - can be enhanced with luminance calculation
        return background == .white || background == .appButtonPrimary ? .black : .white
    }
}

// MARK: - UIColor Bridge (for cases where UIKit is needed)
extension Color {
    var uiColor: UIColor {
        UIColor(self)
    }
}
