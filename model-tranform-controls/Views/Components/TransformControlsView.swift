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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "rotate.3d")
                    .foregroundColor(.blue)
                Text("Transform")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 16) {
                // Rotation Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Rotation")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(viewModel.rotation))°")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.rotation) },
                            set: { viewModel.rotation = Float($0) }
                        ),
                        in: 0...360,
                        step: 1
                    )
                    .accentColor(.blue)
                }
                
                // Scale Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Scale")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.1fx", viewModel.scale))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.scale) },
                            set: { viewModel.scale = Float($0) }
                        ),
                        in: 0.5...2.0,
                        step: 0.1
                    )
                    .accentColor(.blue)
                }
                
                // Animation Speed Control
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Animation Speed")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(String(format: "%.1fx", viewModel.animationSpeed))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(
                        value: Binding(
                            get: { Double(viewModel.animationSpeed) },
                            set: { viewModel.animationSpeed = Float($0) }
                        ),
                        in: 0...3.0,
                        step: 0.1
                    )
                    .accentColor(.blue)
                }
                
                // Animation Toggle
                HStack {
                    Text("Animation")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleAnimation()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: viewModel.isAnimating ? "play.fill" : "pause.fill")
                                .font(.caption)
                            Text(viewModel.isAnimating ? "Live" : "Paused")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(viewModel.isAnimating ? .green : .secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(viewModel.isAnimating ? Color.green.opacity(0.1) : Color.secondary.opacity(0.1))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
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