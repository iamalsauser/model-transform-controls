//
//  USDZModelViewer.swift
//  model-tranform-controls
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI
import SceneKit
import RealityKit

struct USDZModelViewer: View {
    @State private var isModelLoaded = false
    @State private var loadingError: String?
    @State private var modelScale: Float = 1.0
    @State private var modelRotation: Float = 0.0
    @State private var isAnimating = true
    @State private var cameraDistance: Float = 5.0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("USDZ Model Viewer")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: {
                            isAnimating.toggle()
                        }) {
                            Image(systemName: isAnimating ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    
                    // 3D Model View
                    USDZSceneView(
                        isModelLoaded: $isModelLoaded,
                        loadingError: $loadingError,
                        modelScale: $modelScale,
                        modelRotation: $modelRotation,
                        isAnimating: $isAnimating,
                        cameraDistance: $cameraDistance
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Controls
                    VStack(spacing: 16) {
                        // Scale Control
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Scale")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.1fx", modelScale))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: $modelScale, in: 0.1...3.0, step: 0.1)
                                .accentColor(.blue)
                        }
                        
                        // Rotation Control
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Rotation")
                                    .font(.headline)
                                Spacer()
                                Text("\(Int(modelRotation))°")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: $modelRotation, in: 0...360, step: 1)
                                .accentColor(.purple)
                        }
                        
                        // Zoom Control
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Zoom")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.1fx", cameraDistance))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Slider(value: $cameraDistance, in: 2.0...40.0, step: 0.5)
                                .accentColor(.green)
                        }
                        
                        // Status
                        if let error = loadingError {
                            Text("Error: \(error)")
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                        } else if isModelLoaded {
                            Text("✅ USDZ Model Loaded Successfully")
                                .foregroundColor(.green)
                                .font(.caption)
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)
                        } else {
                            HStack {
                                ProgressView()
                                    .scaleEffect(0.8)
                                Text("Loading USDZ Model...")
                                    .font(.caption)
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct USDZSceneView: UIViewRepresentable {
    @Binding var isModelLoaded: Bool
    @Binding var loadingError: String?
    @Binding var modelScale: Float
    @Binding var modelRotation: Float
    @Binding var isAnimating: Bool
    @Binding var cameraDistance: Float
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: USDZSceneView
        var sceneView: SCNView?
        var modelNode: SCNNode?
        var cameraNode: SCNNode?
        
        init(_ parent: USDZSceneView) {
            self.parent = parent
        }
    }
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        context.coordinator.sceneView = sceneView
        
        // Configure SceneKit view
        sceneView.backgroundColor = UIColor.systemBackground
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.antialiasingMode = .multisampling4X
        
        // Create and setup scene
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Setup camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 60
        cameraNode.position = SCNVector3(0, 0, cameraDistance)
        cameraNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(cameraNode)
        context.coordinator.cameraNode = cameraNode
        
        // Setup lighting
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 500
        ambientLight.light?.color = UIColor.white
        scene.rootNode.addChildNode(ambientLight)
        
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 1000
        directionalLight.light?.color = UIColor.white
        directionalLight.position = SCNVector3(5, 5, 5)
        directionalLight.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(directionalLight)
        
        // Load USDZ model
        loadUSDZModel(scene: scene, coordinator: context.coordinator)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update model transform
        if let modelNode = context.coordinator.modelNode {
            modelNode.scale = SCNVector3(modelScale, modelScale, modelScale)
            modelNode.eulerAngles.y = modelRotation * Float.pi / 180.0
            
            // Update animation
            if isAnimating {
                modelNode.isPaused = false
            } else {
                modelNode.isPaused = true
            }
        }
        
        // Update camera distance
        if let cameraNode = context.coordinator.cameraNode {
            cameraNode.position = SCNVector3(0, 0, cameraDistance)
        }
    }
    
    private func loadUSDZModel(scene: SCNScene, coordinator: Coordinator) {
        // Try multiple approaches to load the USDZ model
        var modelLoaded = false
        
        // Approach 1: Load from subdirectory
        if let modelURL = Bundle.main.url(forResource: "heart_model", withExtension: "usdz", subdirectory: "Models/3d_models") {
            do {
                let loadedScene = try SCNScene(url: modelURL, options: [
                    .convertToYUp: true,
                    .convertUnitsToMeters: true
                ])
                
                // Get the root node and clone it
                let modelRootNode = loadedScene.rootNode.clone()
                
                // Apply materials and colors
                // applyMaterialsToNode(modelRootNode) // Removed as per instructions
                
                // Add to scene
                scene.rootNode.addChildNode(modelRootNode)
                coordinator.modelNode = modelRootNode
                
                print("✅ Successfully loaded USDZ model from subdirectory")
                DispatchQueue.main.async {
                    self.isModelLoaded = true
                    self.loadingError = nil
                }
                modelLoaded = true
                
            } catch {
                print("❌ Error loading USDZ from subdirectory: \(error)")
                DispatchQueue.main.async {
                    self.loadingError = "Failed to load USDZ: \(error.localizedDescription)"
                }
            }
        }
        
        // Approach 2: Try loading from bundle root
        if !modelLoaded {
            if let modelURL = Bundle.main.url(forResource: "heart_model", withExtension: "usdz") {
                do {
                    let loadedScene = try SCNScene(url: modelURL, options: [
                        .convertToYUp: true,
                        .convertUnitsToMeters: true
                    ])
                    
                    let modelRootNode = loadedScene.rootNode.clone()
                    // applyMaterialsToNode(modelRootNode) // Removed as per instructions
                    
                    scene.rootNode.addChildNode(modelRootNode)
                    coordinator.modelNode = modelRootNode
                    
                    print("✅ Successfully loaded USDZ model from bundle root")
                    DispatchQueue.main.async {
                        self.isModelLoaded = true
                        self.loadingError = nil
                    }
                    modelLoaded = true
                    
                } catch {
                    print("❌ Error loading USDZ from bundle root: \(error)")
                    DispatchQueue.main.async {
                        self.loadingError = "Failed to load USDZ: \(error.localizedDescription)"
                    }
                }
            }
        }
        
        // Approach 3: Try SCN format as fallback
        if !modelLoaded {
            if let modelURL = Bundle.main.url(forResource: "heart_model", withExtension: "scn", subdirectory: "Models/3d_models") {
                do {
                    let loadedScene = try SCNScene(url: modelURL, options: nil)
                    let modelRootNode = loadedScene.rootNode.clone()
                    // applyMaterialsToNode(modelRootNode) // Removed as per instructions
                    
                    scene.rootNode.addChildNode(modelRootNode)
                    coordinator.modelNode = modelRootNode
                    
                    print("✅ Successfully loaded SCN model as fallback")
                    DispatchQueue.main.async {
                        self.isModelLoaded = true
                        self.loadingError = nil
                    }
                    modelLoaded = true
                    
                } catch {
                    print("❌ Error loading SCN model: \(error)")
                    DispatchQueue.main.async {
                        self.loadingError = "Failed to load SCN model: \(error.localizedDescription)"
                    }
                }
            }
        }
        
        // Approach 4: Create a simple fallback model
        if !modelLoaded {
            print("⚠️ Creating fallback model")
            let fallbackNode = createFallbackModel()
            scene.rootNode.addChildNode(fallbackNode)
            coordinator.modelNode = fallbackNode
            
            DispatchQueue.main.async {
                self.isModelLoaded = true
                self.loadingError = "Using fallback model - USDZ not found"
            }
        }
        
        // Add rotation animation
        if let modelNode = coordinator.modelNode {
            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi) * 2, z: 0, duration: 10.0)
            modelNode.runAction(SCNAction.repeatForever(rotateAction))
        }
    }
    
    private func applyMaterialsToNode(_ node: SCNNode) {
        // Apply materials to the node's geometry
        if let geometry = node.geometry {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.systemBlue
            material.specular.contents = UIColor.white
            material.shininess = 0.8
            geometry.materials = [material]
        }
        
        // Recursively apply to child nodes
        for childNode in node.childNodes {
            applyMaterialsToNode(childNode)
        }
    }
    
    private func createFallbackModel() -> SCNNode {
        let node = SCNNode()
        
        // Create a simple heart shape using spheres
        let leftSphere = SCNNode()
        leftSphere.geometry = SCNSphere(radius: 0.5)
        leftSphere.position = SCNVector3(-0.3, 0.3, 0)
        
        let rightSphere = SCNNode()
        rightSphere.geometry = SCNSphere(radius: 0.5)
        rightSphere.position = SCNVector3(0.3, 0.3, 0)
        
        let bottomCube = SCNNode()
        bottomCube.geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0.1)
        bottomCube.position = SCNVector3(0, -0.2, 0)
        bottomCube.eulerAngles = SCNVector3(0, 0, Float.pi / 4)
        
        // Apply materials
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.systemRed
        material.specular.contents = UIColor.white
        material.shininess = 0.8
        
        leftSphere.geometry?.materials = [material]
        rightSphere.geometry?.materials = [material]
        bottomCube.geometry?.materials = [material]
        
        node.addChildNode(leftSphere)
        node.addChildNode(rightSphere)
        node.addChildNode(bottomCube)
        
        return node
    }
}

// MARK: - Preview
struct USDZModelViewer_Previews: PreviewProvider {
    static var previews: some View {
        USDZModelViewer()
    }
} 