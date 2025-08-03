//
//  TestApp.swift
//  Flam Post Builder Test
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

// Simple test to verify all components compile correctly
struct TestView: View {
    @StateObject private var viewModel = PostBuilderViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Flam Post Builder Test")
                .font(.title)
                .fontWeight(.bold)
            
            Text("✅ All components loaded successfully!")
                .foregroundColor(.green)
            
            // Test basic functionality
            VStack(spacing: 10) {
                Text("Caption: \(viewModel.caption.isEmpty ? "Empty" : viewModel.caption)")
                Text("Selected Model: \(viewModel.selectedModel.displayName)")
                Text("Color: \(viewModel.modelColor.description)")
                Text("Rotation: \(Int(viewModel.rotation))°")
                Text("Scale: \(String(format: "%.1f", viewModel.scale))x")
                Text("Animation Speed: \(String(format: "%.1f", viewModel.animationSpeed))x")
                Text("Is Animating: \(viewModel.isAnimating ? "Yes" : "No")")
            }
            .font(.caption)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            
            Button("Test Model Change") {
                viewModel.selectedModel = viewModel.selectedModel == .heart ? .sparkles : .heart
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    TestView()
} 