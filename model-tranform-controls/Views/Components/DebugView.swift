//
//  DebugView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

struct DebugView: View {
    @ObservedObject var viewModel: PostBuilderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Debug Info")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Selected Model: \(viewModel.selectedModel.displayName)")
                    .font(.caption)
                Text("Color: \(viewModel.modelColor.description)")
                    .font(.caption)
                Text("Rotation: \(Int(viewModel.rotation))°")
                    .font(.caption)
                Text("Scale: \(String(format: "%.1f", viewModel.scale))x")
                    .font(.caption)
                Text("Animation Speed: \(String(format: "%.1f", viewModel.animationSpeed))x")
                    .font(.caption)
                Text("Is Animating: \(viewModel.isAnimating ? "Yes" : "No")")
                    .font(.caption)
                Text("Model Node Exists: \(viewModel.sceneModel.modelNode != nil ? "Yes" : "No")")
                    .font(.caption)
                    .foregroundColor(viewModel.sceneModel.modelNode != nil ? .green : .red)
            }
            .padding(8)
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    DebugView(viewModel: PostBuilderViewModel())
} 