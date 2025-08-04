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
            ScrollView {
                VStack(spacing: 16) {
                    // 3D Preview Section
                    previewSection
                    
                    // Content Creation Section
                    VStack(spacing: 16) {
                        // Caption Input
                        CaptionInputView(viewModel: viewModel)
                        
                        // Model Selector
                        ModelSelectorView(viewModel: viewModel)
                        
                        // Color Picker
                        ColorPickerView(viewModel: viewModel)
                        
                        // Transform Controls
                        TransformControlsView(viewModel: viewModel)
                        
                        // Debug View (temporary)
                        DebugView(viewModel: viewModel)
                        
                        // Create Post Button
                        createPostButton
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Create Post")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Preview") {
                        // Preview functionality
                    }
                    .fontWeight(.medium)
                }
            }
        }
        .alert("🎉 Post Created!", isPresented: $viewModel.showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Your immersive post has been created successfully!")
        }
    }
    

    
    // MARK: - Preview Section
    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Preview")
                    .font(.headline)
                    .fontWeight(.semibold)
                
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
            
            // 3D Scene
            SceneKitView(viewModel: viewModel)
                .frame(height: 280)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 0.5)
                )
        }
        .padding(.horizontal, 16)
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
                        .font(.body)
                }
                
                Text(viewModel.isCreatingPost ? "Creating..." : "Create Post")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(viewModel.canCreatePost ? Color.blue : Color(.systemGray4))
            )
        }
        .disabled(!viewModel.canCreatePost || viewModel.isCreatingPost)
        .buttonStyle(PlainButtonStyle())
    }
    

}

// MARK: - Preview
struct PostBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        PostBuilderView()
    }
} 