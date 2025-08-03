//
//  PostModel.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import Foundation
import SwiftUI

struct PostModel: Identifiable {
    let id = UUID()
    var caption: String
    var selectedModel: ModelType
    var modelColor: Color
    var rotation: Float
    var scale: Float
    var animationSpeed: Float
    var isAnimating: Bool
    var createdAt: Date
    
    init(caption: String = "", 
         selectedModel: ModelType = .heart,
         modelColor: Color = .red,
         rotation: Float = 0,
         scale: Float = 1.0,
         animationSpeed: Float = 1.0,
         isAnimating: Bool = true) {
        self.caption = caption
        self.selectedModel = selectedModel
        self.modelColor = modelColor
        self.rotation = rotation
        self.scale = scale
        self.animationSpeed = animationSpeed
        self.isAnimating = isAnimating
        self.createdAt = Date()
    }
}

enum ModelType: String, CaseIterable, Codable {
    case heart = "heart"
    case sparkles = "sparkles"
    case lightning = "lightning"
    
    var displayName: String {
        switch self {
        case .heart: return "💖 Heart"
        case .sparkles: return "✨ Sparkles"
        case .lightning: return "⚡ Energy"
        }
    }
    
    var description: String {
        switch self {
        case .heart: return "Pulsing love"
        case .sparkles: return "Magic moment"
        case .lightning: return "Electric vibe"
        }
    }
    
    var iconName: String {
        switch self {
        case .heart: return "heart.fill"
        case .sparkles: return "sparkles"
        case .lightning: return "bolt.fill"
        }
    }
} 