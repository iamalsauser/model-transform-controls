//
//  TransformControlsView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

struct TransformControlsView: View {
    @ObservedObject var viewModel: PostBuilderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "rotate.3d")
                    .foregroundColor(.purple)
                Text("Transform Controls")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 20) {
                // Rotation Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Rotation")
                            .font(.subheadline)
                            .foregroundColor(.purple.opacity(0.8))
                        Spacer()
                        Text("\(Int(viewModel.rotation))°")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.rotation) },
                            set: { viewModel.rotation = Float($0) }
                        ),
                        in: 0...360,
                        step: 1
                    )
                    .accentColor(.purple)
                }
                
                // Scale Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Scale")
                            .font(.subheadline)
                            .foregroundColor(.purple.opacity(0.8))
                        Spacer()
                        Text(String(format: "%.1fx", viewModel.scale))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.scale) },
                            set: { viewModel.scale = Float($0) }
                        ),
                        in: 0.5...2.0,
                        step: 0.1
                    )
                    .accentColor(.purple)
                }
                
                // Animation Speed Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Animation Speed")
                            .font(.subheadline)
                            .foregroundColor(.purple.opacity(0.8))
                        Spacer()
                        Text(String(format: "%.1fx", viewModel.animationSpeed))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.animationSpeed) },
                            set: { viewModel.animationSpeed = Float($0) }
                        ),
                        in: 0...3.0,
                        step: 0.1
                    )
                    .accentColor(.purple)
                }
                
                // Animation Toggle
                HStack {
                    Text("Animation")
                        .font(.subheadline)
                        .foregroundColor(.purple.opacity(0.8))
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleAnimation()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: viewModel.isAnimating ? "play.circle.fill" : "pause.circle.fill")
                                .font(.title3)
                            Text(viewModel.isAnimating ? "Live" : "Paused")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(viewModel.isAnimating ? .green : .gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(viewModel.isAnimating ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(viewModel.isAnimating ? Color.green.opacity(0.3) : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.4))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Preview
struct TransformControlsView_Previews: PreviewProvider {
    static var previews: some View {
        TransformControlsView(viewModel: PostBuilderViewModel())
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
} 