//
//  AppColors.swift
//  DefyBlog
//
//  Centralized color definitions for the app's design system
//

import SwiftUI

struct AppColors {
    // MARK: - Background Colors
    static let primaryBackground = Color.black
    static let secondaryBackground = Color(hex: "1A1A1A")
    
    // MARK: - Text Colors
    static let primaryText = Color.white
    static let secondaryText = Color(hex: "B3B3B3")
    
    // MARK: - Brand Colors
    static let primaryBlue = Color(hex: "0558B9")
    static let lightBlue = Color(hex: "91CAF8")
    
    // MARK: - UI Element Colors
    static let cardBackground = Color(hex: "1A1A1A")
    static let inputBackground = Color(hex: "1A1A1A")
    static let buttonPrimary = Color.white
    static let buttonSecondary = Color(hex: "B3B3B3")
    
    // MARK: - Accent Colors
    static let accentColor = Color(hex: "0558B9")
    static let selectedAccent = Color(hex: "91CAF8")
    
    // MARK: - Semantic Colors
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.yellow
}

// MARK: - Color Extension for Hex Support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
