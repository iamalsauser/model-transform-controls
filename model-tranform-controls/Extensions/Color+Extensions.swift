//
//  Color+Extensions.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

extension Color {
    // MARK: - Custom Colors
    static let flamPurple = Color(red: 147/255, green: 51/255, blue: 234/255)
    static let flamPink = Color(red: 236/255, green: 72/255, blue: 153/255)
    static let flamBlue = Color(red: 59/255, green: 130/255, blue: 246/255)
    
    // MARK: - Hex Color Support
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
    
    // MARK: - UIColor Conversion
    var uiColor: UIColor {
        UIColor(self)
    }
    
    // MARK: - Brightness
    var brightness: Double {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return Double(red * 0.299 + green * 0.587 + blue * 0.114)
    }
    
    // MARK: - Contrast Color
    var contrastColor: Color {
        return brightness > 0.5 ? .black : .white
    }
    
    // MARK: - Gradient Colors
    static var flamGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [flamPink, flamPurple, flamBlue]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
} 