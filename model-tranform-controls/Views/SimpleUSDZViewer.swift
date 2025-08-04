//
//  SimpleUSDZViewer.swift
//  model-tranform-controls
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI
import SceneKit

struct SimpleUSDZViewer: View {
    @State private var isModelLoaded = false
    @State private var loadingError: String?
    @State private var modelScale: Float = 1.0
    @State private var modelRotation: Float = 0.0
    @State private var cameraDistance: Float = 5.0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Simple USDZ Viewer")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if isModelLoaded {
                        Text("✅ Loaded")
                            .foregroundColor(.green)
                            .font(.caption)
                    } else if let error = loadingError {
                        Text("❌ Error")
                            .foregroundColor(.red)
                            .font(.caption)
                    } else {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
                
                // 3D Model View
                SimpleUSDZSceneView(
                    isModelLoaded: $isModelLoaded,
                    loadingError: $loadingError,
                    modelScale: $modelScale,
                    modelRotation: $modelRotation,
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
                    }
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .navigationBarHidden(true)
    }
}

struct SimpleUSDZSceneView: UIViewRepresentable {
    @Binding var isModelLoaded: Bool
    @Binding var loadingError: String?
    @Binding var modelScale: Float
    @Binding var modelRotation: Float
    @Binding var cameraDistance: Float
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: SimpleUSDZSceneView
        var sceneView: SCNView?
        var modelNode: SCNNode?
        var cameraNode: SCNNode?
        
        init(_ parent: SimpleUSDZSceneView) {
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
        }
        
        // Update camera distance
        if let cameraNode = context.coordinator.cameraNode {
            cameraNode.position = SCNVector3(0, 0, cameraDistance)
        }
    }
    
    private func loadUSDZModel(scene: SCNScene, coordinator: Coordinator) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Copy USDZ file to documents directory first
            if let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let usdzFileName = "heart_model.usdz"
                let documentsURL = documentsPath.appendingPathComponent(usdzFileName)
                
                // Check if file already exists in documents
                if !FileManager.default.fileExists(atPath: documentsURL.path) {
                    // Try multiple bundle locations
                    var bundleURL: URL?
                    
                    // Try subdirectory first
                    bundleURL = Bundle.main.url(forResource: "heart_model", withExtension: "usdz", subdirectory: "Models/3d_models")
                    
                    // If not found, try bundle root
                    if bundleURL == nil {
                        bundleURL = Bundle.main.url(forResource: "heart_model", withExtension: "usdz")
                    }
                    
                    // If still not found, try SCN file
                    if bundleURL == nil {
                        bundleURL = Bundle.main.url(forResource: "heart_model", withExtension: "scn", subdirectory: "Models/3d_models")
                    }
                    
                    if let bundleURL = bundleURL {
                        do {
                            try FileManager.default.copyItem(at: bundleURL, to: documentsURL)
                            print("✅ Copied model to documents: \(documentsURL.path)")
                        } catch {
                            print("❌ Failed to copy model: \(error)")
                            DispatchQueue.main.async {
                                self.loadingError = "Failed to copy model: \(error.localizedDescription)"
                            }
                            return
                        }
                    } else {
                        print("❌ Could not find model in bundle")
                        DispatchQueue.main.async {
                            self.loadingError = "Model file not found in bundle"
                        }
                        return
                    }
                }
                
                // Now load from documents directory
                do {
                    let options: [SCNSceneSource.LoadingOption: Any] = documentsURL.pathExtension == "usdz" ? [
                        .convertToYUp: true,
                        .convertUnitsToMeters: true
                    ] : [:]
                    
                    let loadedScene = try SCNScene(url: documentsURL, options: options)
                    
                    // Get the root node and clone it
                    let modelRootNode = loadedScene.rootNode.clone()
                    
                    // Apply materials and colors
                    // applyMaterialsToNode(modelRootNode) // Removed as per edit hint
                    
                    // Add to scene
                    DispatchQueue.main.async {
                        scene.rootNode.addChildNode(modelRootNode)
                        coordinator.modelNode = modelRootNode
                        
                        // Add rotation animation
                        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi) * 2, z: 0, duration: 10.0)
                        modelRootNode.runAction(SCNAction.repeatForever(rotateAction))
                        
                        self.isModelLoaded = true
                        self.loadingError = nil
                    }
                    
                    print("✅ Successfully loaded USDZ from documents")
                    
                } catch {
                    print("❌ Error loading USDZ from documents: \(error)")
                    DispatchQueue.main.async {
                        self.loadingError = "Failed to load USDZ: \(error.localizedDescription)"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loadingError = "Could not access documents directory"
                }
            }
        }
    }
    
    // Remove or comment out the applyMaterialsToNode function and all its calls
    // private func applyMaterialsToNode(_ node: SCNNode) {
    //     // Apply materials to the node's geometry
    //     if let geometry = node.geometry {
    //         let material = SCNMaterial()
    //         material.diffuse.contents = UIColor.systemBlue
    //         material.specular.contents = UIColor.white
    //         material.shininess = 0.8
    //         geometry.materials = [material]
    //     }
        
    //     // Recursively apply to child nodes
    //     for childNode in node.childNodes {
    //         applyMaterialsToNode(childNode)
    //     }
    // }
}

// MARK: - Preview
struct SimpleUSDZViewer_Previews: PreviewProvider {
    static var previews: some View {
        SimpleUSDZViewer()
    }
} 