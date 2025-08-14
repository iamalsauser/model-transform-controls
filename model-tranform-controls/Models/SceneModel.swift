//
//  SceneModel.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import Foundation
import SceneKit
import SwiftUI

class SceneModel: ObservableObject {
    var scene: SCNScene
    var rootNode: SCNNode
    var cameraNode: SCNNode
    var modelNode: SCNNode?
    private var currentModelType: ModelType = .heart
    
    init() {
        self.scene = SCNScene()
        self.rootNode = SCNNode()
        self.cameraNode = SCNNode()
        
        setupScene()
        // Create initial model
        updateModel(.heart, color: .red)
    }
    
    private func setupScene() {
        // Add root node to scene
        scene.rootNode.addChildNode(rootNode)
        
        // Setup camera with better positioning
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.fieldOfView = 60
        cameraNode.position = SCNVector3(0, 0, 8)
        cameraNode.look(at: SCNVector3(0, 0, 0))
        rootNode.addChildNode(cameraNode)
        
        // Add ambient lighting for better visibility
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 300
        ambientLight.light?.color = UIColor.white
    
        rootNode.addChildNode(ambientLight)
        
        // Add directional lighting
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 1000
        directionalLight.light?.color = UIColor.white
        directionalLight.position = SCNVector3(5, 5, 5)
        directionalLight.look(at: SCNVector3(0, 0, 0))
        rootNode.addChildNode(directionalLight)
        
        
        // Add point light for better illumination
        let pointLight = SCNNode()
        pointLight.light = SCNLight()
        pointLight.light?.type = .omni
        pointLight.light?.intensity = 500
        pointLight.light?.color = UIColor.white
        pointLight.position = SCNVector3(0, 2, 3)
        rootNode.addChildNode(pointLight)
    }
    
    func updateModel(_ modelType: ModelType, color: Color) {
        print("🎨 Creating model: \(modelType) with color: \(color)")
        
        // Remove existing model
        modelNode?.removeFromParentNode()
        
        // Update current model type
        currentModelType = modelType
        
        // All models now use the heart_model.usdz for demonstration
        modelNode = createUSDZModel(color: color, modelType: modelType)
        
        if let modelNode = modelNode {
            rootNode.addChildNode(modelNode)
            print("✅ USDZ model added to scene: \(modelType)")
        } else {
            print("❌ Failed to create USDZ model: \(modelType)")
        }
    }
    
    private func createUSDZModel(color: Color, modelType: ModelType) -> SCNNode {
        let modelNode = SCNNode()
        var modelLoaded = false
        
        // Load USDZ model from the specified path
        if let modelURL = Bundle.main.url(forResource: "heart_model", withExtension: "usdz", subdirectory: "Models/3d_models") {
            do {
                let loadedScene = try SCNScene(url: modelURL, options: [
                    .convertToYUp: true,
                    .convertUnitsToMeters: true
                ])
                
                // Clone the entire scene structure
                let modelRootNode = loadedScene.rootNode.clone()
                
                // Apply color and material properties
                applyColorToNode(modelRootNode, color: color)
                
                // Add to model node
                modelNode.addChildNode(modelRootNode)
                print("✅ Successfully loaded USDZ model: \(modelURL.lastPathComponent) for \(modelType)")
                modelLoaded = true
                
                // Apply different scaling and positioning based on model type
                switch modelType {
                case .heart:
                    modelNode.scale = SCNVector3(2.0, 2.0, 2.0)
                    modelNode.position = SCNVector3(0, 0, 0)
                case .sparkles:
                    modelNode.scale = SCNVector3(1.5, 1.5, 1.5)
                    modelNode.position = SCNVector3(0, 0, 0)
                case .lightning:
                    modelNode.scale = SCNVector3(1.8, 1.8, 1.8)
                    modelNode.position = SCNVector3(0, 0, 0)
                }
                
            } catch {
                print("❌ Error loading USDZ model: \(error.localizedDescription)")
            }
        } else {
            print("❌ Could not find heart_model.usdz at path: Models/3d_models/")
        }
        
        // Fallback to SCN if USDZ fails
        if !modelLoaded {
            if let modelURL = Bundle.main.url(forResource: "heart_model", withExtension: "scn", subdirectory: "Models/3d_models") {
                do {
                    let loadedScene = try SCNScene(url: modelURL, options: nil)
                    let modelRootNode = loadedScene.rootNode.clone()
                    applyColorToNode(modelRootNode, color: color)
                    modelNode.addChildNode(modelRootNode)
                    print("✅ Loaded model from SCN file for \(modelType)")
                    modelLoaded = true
                    
                    // Apply scaling for SCN fallback
                    modelNode.scale = SCNVector3(1.5, 1.5, 1.5)
                    modelNode.position = SCNVector3(0, 0, 0)
                    
                } catch {
                    print("❌ Error loading SCN model: \(error.localizedDescription)")
                }
            }
        }
        
        // Final fallback to procedural model
        if !modelLoaded {
            print("⚠️ Using procedural fallback for \(modelType)")
            switch modelType {
            case .heart:
                modelNode.addChildNode(createProceduralHeart(color: color))
            case .sparkles:
                modelNode.addChildNode(createProceduralSparkles(color: color))
            case .lightning:
                modelNode.addChildNode(createProceduralLightning(color: color))
            }
        }
        
        // Add appropriate animation based on model type
        addModelAnimation(to: modelNode, modelType: modelType)
        
        return modelNode
    }
    
    private func createProceduralHeart(color: Color) -> SCNNode {
        let heartGroup = SCNNode()
        
        // Create heart shape using two spheres and a rotated cube
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
        
        // Apply material to all parts
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(color)
        material.emission.contents = UIColor(color).withAlphaComponent(0.3)
        material.specular.contents = UIColor.white
        material.shininess = 0.8
        
        leftSphere.geometry?.materials = [material]
        rightSphere.geometry?.materials = [material]
        bottomCube.geometry?.materials = [material]
        
        heartGroup.addChildNode(leftSphere)
        heartGroup.addChildNode(rightSphere)
        heartGroup.addChildNode(bottomCube)
        
        return heartGroup
    }
    
    private func createProceduralSparkles(color: Color) -> SCNNode {
        let sparklesGroup = SCNNode()
        
        // Create multiple sparkle particles
        for i in 0..<8 {
            let sparkle = SCNNode()
            
            // Create star-like geometry using spheres
            let starGeometry = SCNSphere(radius: 0.15)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(color)
            material.emission.contents = UIColor(color).withAlphaComponent(0.8)
            material.specular.contents = UIColor.white
            material.shininess = 1.0
            starGeometry.materials = [material]
            
            sparkle.geometry = starGeometry
            
            // Position in layered circles
            let layer = i < 4 ? 0 : 1
            let angle = Float(i % 4) * Float.pi * 2 / 4
            let radius: Float = layer == 0 ? 1.2 : 1.8
            let height: Float = layer == 0 ? 0 : 0.5
            
            sparkle.position = SCNVector3(
                cos(angle) * radius,
                sin(angle) * radius + height,
                Float.random(in: -0.2...0.2)
            )
            
            sparklesGroup.addChildNode(sparkle)
        }
        
        return sparklesGroup
    }
    
    private func createProceduralLightning(color: Color) -> SCNNode {
        let lightningGroup = SCNNode()
        
        // Create zigzag lightning bolt using multiple cylinders
        let segments = [
            (SCNVector3(0, 1.0, 0), 0.0),
            (SCNVector3(0.3, 0.5, 0), 0.3),
            (SCNVector3(-0.2, 0, 0), -0.2),
            (SCNVector3(0.4, -0.5, 0), 0.4),
            (SCNVector3(0, -1.0, 0), 0.0)
        ]
        
        for segment in segments {
            let bolt = SCNNode()
            let boltGeometry = SCNCylinder(radius: 0.08, height: 0.6)
            
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(color)
            material.emission.contents = UIColor(color).withAlphaComponent(0.9)
            material.specular.contents = UIColor.white
            material.shininess = 1.0
            boltGeometry.materials = [material]
            
            bolt.geometry = boltGeometry
            bolt.position = segment.0
            bolt.eulerAngles.z = Float(segment.1)
            
            lightningGroup.addChildNode(bolt)
        }
        
        return lightningGroup
    }
    
    private func addModelAnimation(to node: SCNNode, modelType: ModelType) {
        switch modelType {
        case .heart:
            // Heart animation: gentle pulse and rotation
            let pulseAction = SCNAction.sequence([
                SCNAction.scale(to: 1.2, duration: 0.8),
                SCNAction.scale(to: 1.0, duration: 0.8)
            ])
            node.runAction(SCNAction.repeatForever(pulseAction))
            
            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi) * 0.1, z: 0, duration: 2.0)
            node.runAction(SCNAction.repeatForever(rotateAction))
            
        case .sparkles:
            // Sparkles animation: orbital rotation with individual sparkle movement
            let orbitAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(Float.pi) * 2, duration: 5.0)
            node.runAction(SCNAction.repeatForever(orbitAction))
            
            // Add individual sparkle animations to child nodes
            node.childNodes.forEach { sparkle in
                let sparkleAction = SCNAction.rotateBy(
                    x: CGFloat(Float.random(in: 0...Float.pi)),
                    y: CGFloat(Float.random(in: 0...Float.pi)),
                    z: CGFloat(Float.random(in: 0...Float.pi)),
                    duration: Double.random(in: 1.5...3.0)
                )
                sparkle.runAction(SCNAction.repeatForever(sparkleAction))
            }
            
        case .lightning:
            // Lightning animation: electric flicker effect
            let flickerAction = SCNAction.sequence([
                SCNAction.fadeOpacity(to: 0.3, duration: 0.1),
                SCNAction.fadeOpacity(to: 1.0, duration: 0.1)
            ])
            node.runAction(SCNAction.repeatForever(flickerAction))
            
            // Add slight rotation for dynamic effect
            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi) * 0.05, z: 0, duration: 1.5)
            node.runAction(SCNAction.repeatForever(rotateAction))
        }
    }
    
    private func applyColorToNode(_ node: SCNNode, color: Color) {
        // Apply color to the node's geometry if it exists
        if let geometry = node.geometry {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(color)
            material.emission.contents = UIColor(color).withAlphaComponent(0.3)
            material.specular.contents = UIColor.white
            material.shininess = 0.8
            material.transparency = 1.0
            
            // Preserve existing materials if they exist, otherwise create new
            if geometry.materials.isEmpty {
                geometry.materials = [material]
            } else {
                // Update existing materials
                for existingMaterial in geometry.materials {
                    existingMaterial.diffuse.contents = UIColor(color)
                    existingMaterial.emission.contents = UIColor(color).withAlphaComponent(0.3)
                }
            }
        }
        
        // Recursively apply color to all child nodes
        for childNode in node.childNodes {
            applyColorToNode(childNode, color: color)
        }
    }
    

    
    func updateTransform(rotation: Float, scale: Float) {
        if let modelNode = modelNode {
            modelNode.eulerAngles.z = rotation * Float.pi / 180
            modelNode.scale = SCNVector3(scale, scale, scale)
            print("🔄 Transform updated: rotation=\(rotation)°, scale=\(scale)x")
        } else {
            print("⚠️ No model node to transform")
        }
    }
    
    func updateAnimationSpeed(_ speed: Float) {
        guard let modelNode = modelNode else { return }
        
        // Remove existing animations
        modelNode.removeAllActions()
        modelNode.enumerateChildNodes { node, _ in
            node.removeAllActions()
        }
        
        // Recreate animations with new speed
        let speedMultiplier = speed > 0 ? 1.0 / speed : 1.0
        
        // Use unified animation recreation for all model types
        recreateModelAnimation(modelNode: modelNode, modelType: currentModelType, speedMultiplier: speedMultiplier)
    }
    
    private func recreateModelAnimation(modelNode: SCNNode, modelType: ModelType, speedMultiplier: Float) {
        switch modelType {
        case .heart:
            // Heart animation: gentle pulse and rotation
            let pulseAction = SCNAction.sequence([
                SCNAction.scale(to: 1.2, duration: 0.8 * Double(speedMultiplier)),
                SCNAction.scale(to: 1.0, duration: 0.8 * Double(speedMultiplier))
            ])
            modelNode.runAction(SCNAction.repeatForever(pulseAction))
            
            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi) * 0.1, z: 0, duration: 2.0 * Double(speedMultiplier))
            modelNode.runAction(SCNAction.repeatForever(rotateAction))
            
        case .sparkles:
            // Sparkles animation: orbital rotation with individual sparkle movement
            modelNode.childNodes.forEach { sparkle in
                let sparkleAction = SCNAction.rotateBy(
                    x: CGFloat(Float.random(in: 0...Float.pi)),
                    y: CGFloat(Float.random(in: 0...Float.pi)),
                    z: CGFloat(Float.random(in: 0...Float.pi)),
                    duration: Double.random(in: 1.5...3.0) * Double(speedMultiplier)
                )
                sparkle.runAction(SCNAction.repeatForever(sparkleAction))
            }
            
            let orbitAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(Float.pi) * 2, duration: 5.0 * Double(speedMultiplier))
            modelNode.runAction(SCNAction.repeatForever(orbitAction))
            
        case .lightning:
            // Lightning animation: electric flicker effect
            modelNode.childNodes.enumerated().forEach { (i, bolt) in
                let flickerAction = SCNAction.sequence([
                    SCNAction.wait(duration: Double(i) * 0.05 * Double(speedMultiplier)),
                    SCNAction.sequence([
                        SCNAction.fadeOpacity(to: 0.3, duration: 0.1 * Double(speedMultiplier)),
                        SCNAction.fadeOpacity(to: 1.0, duration: 0.1 * Double(speedMultiplier))
                    ])
                ])
                bolt.runAction(SCNAction.repeatForever(flickerAction))
            }
            
            // Add slight rotation for dynamic effect
            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi) * 0.05, z: 0, duration: 1.5 * Double(speedMultiplier))
            modelNode.runAction(SCNAction.repeatForever(rotateAction))
        }
    }
    
    func pauseAnimations() {
        modelNode?.isPaused = true
        modelNode?.enumerateChildNodes { node, _ in
            node.isPaused = true
        }
    }
    
    func resumeAnimations() {
        modelNode?.isPaused = false
        modelNode?.enumerateChildNodes { node, _ in
            node.isPaused = false
        }
    }
}
