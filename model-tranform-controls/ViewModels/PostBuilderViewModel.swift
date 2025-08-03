//
//  PostBuilderViewModel.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PostBuilderViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var caption: String = ""
    @Published var selectedModel: ModelType = .heart
    @Published var modelColor: Color = .red
    @Published var rotation: Float = 0
    @Published var scale: Float = 1.0
    @Published var animationSpeed: Float = 1.0
    @Published var isAnimating: Bool = true
    @Published var showPreview: Bool = true
    
    // MARK: - Scene Management
    @Published var sceneModel: SceneModel = SceneModel()
    
    // MARK: - UI State
    @Published var isCreatingPost: Bool = false
    @Published var showSuccessAlert: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        updateScene()
    }
    
    // MARK: - Setup
    private func setupBindings() {
        // Update scene when model or color changes
        Publishers.CombineLatest($selectedModel, $modelColor)
            .sink { [weak self] model, color in
                self?.updateScene()
            }
            .store(in: &cancellables)
        
        // Update transforms when rotation or scale changes
        Publishers.CombineLatest($rotation, $scale)
            .sink { [weak self] rotation, scale in
                self?.updateTransforms()
            }
            .store(in: &cancellables)
        
        // Update animation speed
        $animationSpeed
            .sink { [weak self] speed in
                self?.updateAnimationSpeed(speed)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Scene Updates
    private func updateScene() {
        sceneModel.updateModel(selectedModel, color: modelColor)
    }
    
    private func updateTransforms() {
        sceneModel.updateTransform(rotation: rotation, scale: scale)
    }
    
    private func updateAnimationSpeed(_ speed: Float) {
        sceneModel.updateAnimationSpeed(speed)
    }
    
    // MARK: - Public Methods
    func toggleAnimation() {
        isAnimating.toggle()
        if isAnimating {
            // Resume animations
            sceneModel.resumeAnimations()
        } else {
            // Pause animations
            sceneModel.pauseAnimations()
        }
    }
    
    func createPost() {
        guard !caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isCreatingPost = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.isCreatingPost = false
            self?.showSuccessAlert = true
            
            // Reset form after successful post
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self?.resetForm()
            }
        }
    }
    
    private func resetForm() {
        caption = ""
        selectedModel = .heart
        modelColor = .red
        rotation = 0
        scale = 1.0
        animationSpeed = 1.0
        isAnimating = true
    }
    
    // MARK: - Color Presets
    let colorPresets: [Color] = [
        .red,
        .blue,
        .green,
        .yellow,
        .purple,
        .orange
    ]
    
    func setColor(_ color: Color) {
        modelColor = color
    }
    
    // MARK: - Validation
    var canCreatePost: Bool {
        !caption.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var captionCharacterCount: Int {
        caption.count
    }
    
    var isCaptionValid: Bool {
        captionCharacterCount <= 280
    }
} 