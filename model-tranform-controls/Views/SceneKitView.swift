//
//  SceneKitView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    @ObservedObject var viewModel: PostBuilderViewModel
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = viewModel.sceneModel.scene
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.systemGray6
        sceneView.antialiasingMode = .multisampling4X
        
        // Enable auto-lighting for better visibility
        sceneView.autoenablesDefaultLighting = true
        
        // Set up camera controls
        sceneView.cameraControlConfiguration.allowsTranslation = false
        sceneView.cameraControlConfiguration.autoSwitchToFreeCamera = false
        
        // Add gesture recognizers for custom controls
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        sceneView.addGestureRecognizer(tapGesture)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update scene when viewModel changes
        uiView.scene = viewModel.sceneModel.scene
        
        // Update camera position for better viewing
        viewModel.sceneModel.cameraNode.position = SCNVector3(0, 0, 8)
        
        // Ensure the scene is properly set up
        if viewModel.sceneModel.modelNode == nil {
            viewModel.sceneModel.updateModel(viewModel.selectedModel, color: viewModel.modelColor)
        }
        
        // Force a render update
        uiView.setNeedsDisplay()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: SceneKitView
        
        init(_ parent: SceneKitView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            // Handle tap gestures if needed
            let location = gesture.location(in: gesture.view)
            print("Tapped at: \(location)")
        }
    }
}

// MARK: - Preview
struct SceneKitView_Previews: PreviewProvider {
    static var previews: some View {
        SceneKitView(viewModel: PostBuilderViewModel())
            .frame(height: 300)
            .background(Color.black.opacity(0.1))
    }
} 