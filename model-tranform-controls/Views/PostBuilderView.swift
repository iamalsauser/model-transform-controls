//
//  PostBuilderView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

struct PostBuilderView: View {
    @StateObject private var viewModel = PostBuilderViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.purple.opacity(0.9),
                        Color.blue.opacity(0.9),
                        Color.indigo.opacity(0.9)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        // Main content
                        HStack(alignment: .top, spacing: 20) {
                            // Left column - 3D Preview and Controls
                            VStack(spacing: 20) {
                                // 3D Preview
                                previewSection
                                
                                // Transform Controls
                                TransformControlsView(viewModel: viewModel)
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Right column - Content Creation
                            VStack(spacing: 20) {
                                // Caption Input
                                CaptionInputView(viewModel: viewModel)
                                
                                // Model Selector
                                ModelSelectorView(viewModel: viewModel)
                                
                                // Color Picker
                                ColorPickerView(viewModel: viewModel)
                                
                                // Create Post Button
                                createPostButton
                                
                                // Architecture Note
                                architectureNote
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .alert("🎉 Post Created!", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Your immersive post has been created successfully!")
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "camera.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.pink, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Flam Post Builder")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Create Immersive Social Posts")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            Spacer()
            
            Text("iOS Prototype")
                .font(.caption)
                .foregroundColor(.purple.opacity(0.8))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.1))
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    // MARK: - Preview Section
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("3D Preview")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
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
            
            ZStack {
                // 3D Scene
                SceneKitView(viewModel: viewModel)
                    .frame(height: 320)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                
                // Overlay label
                VStack {
                    HStack {
                        Text("SwiftUI → SceneKit Integration")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.black.opacity(0.6))
                            )
                        Spacer()
                    }
                    Spacer()
                }
                .padding(16)
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
    
    // MARK: - Create Post Button
    private var createPostButton: some View {
        Button(action: {
            viewModel.createPost()
        }) {
            HStack(spacing: 8) {
                if viewModel.isCreatingPost {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "paperplane.fill")
                        .font(.title3)
                }
                
                Text(viewModel.isCreatingPost ? "Creating..." : "Create Immersive Post")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: viewModel.canCreatePost ? [Color.pink, Color.purple] : [Color.gray.opacity(0.5)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: viewModel.canCreatePost ? Color.purple.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
        }
        .disabled(!viewModel.canCreatePost || viewModel.isCreatingPost)
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Architecture Note
    private var architectureNote: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.purple)
                Text("Architecture")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple.opacity(0.8))
            }
            
            Text("SwiftUI handles UI state management, SceneKit renders 3D content. Ready for Unreal Engine integration via UIViewRepresentable bridge.")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .lineLimit(nil)
        }
        .padding()
        .background(Color.black.opacity(0.6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Preview
struct PostBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        PostBuilderView()
    }
} 