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
        
        // Create new model based on type
        switch modelType {
        case .heart:
            modelNode = createHeartModel(color: color)
        case .sparkles:
            modelNode = createSparklesModel(color: color)
        case .lightning:
            modelNode = createLightningModel(color: color)
        }
        
        if let modelNode = modelNode {
            rootNode.addChildNode(modelNode)
            print("✅ Model added to scene: \(modelType)")
        } else {
            print("❌ Failed to create model: \(modelType)")
        }
    }
    
    private func createHeartModel(color: Color) -> SCNNode {
        let heartNode = SCNNode()
        
        // Create a simple heart using a sphere with custom material
        let heartGeometry = SCNSphere(radius: 1.0)
        
        // Create material with better visibility
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(color)
        material.emission.contents = UIColor(color).withAlphaComponent(0.5)
        material.specular.contents = UIColor.white
        material.shininess = 0.8
        material.transparency = 1.0
        
        heartGeometry.materials = [material]
        heartNode.geometry = heartGeometry
        
        // Position the heart properly
        heartNode.position = SCNVector3(0, 0, 0)
        heartNode.scale = SCNVector3(1, 1, 1)
        
        // Add pulse animation
        let pulseAction = SCNAction.sequence([
            SCNAction.scale(to: 1.3, duration: 0.8),
            SCNAction.scale(to: 1.0, duration: 0.8)
        ])
        heartNode.runAction(SCNAction.repeatForever(pulseAction))
        
        return heartNode
    }
    
    private func createSparklesModel(color: Color) -> SCNNode {
        let sparklesNode = SCNNode()
        
        // Create multiple sparkle particles
        for i in 0..<6 {
            let sparkle = SCNNode()
            
            // Create larger, more visible star geometry
            let starGeometry = SCNSphere(radius: 0.2)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(color)
            material.emission.contents = UIColor(color).withAlphaComponent(0.7)
            material.specular.contents = UIColor.white
            material.shininess = 1.0
            starGeometry.materials = [material]
            
            sparkle.geometry = starGeometry
            
            // Position in circle with larger radius
            let angle = Float(i) * Float.pi * 2 / 6
            let radius: Float = 1.5
            sparkle.position = SCNVector3(cos(angle) * radius, sin(angle) * radius, 0)
            
            // Add rotation animation
            let rotateAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(Float.pi) * 2, duration: 2.0)
            sparkle.runAction(SCNAction.repeatForever(rotateAction))
            
            sparklesNode.addChildNode(sparkle)
        }
        
        // Add orbital animation
        let orbitAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(Float.pi) * 2, duration: 4.0)
        sparklesNode.runAction(SCNAction.repeatForever(orbitAction))
        
        return sparklesNode
    }
    
    private func createLightningModel(color: Color) -> SCNNode {
        let lightningNode = SCNNode()
        
        // Create a simple lightning bolt using a cylinder
        let lightningGeometry = SCNCylinder(radius: 0.1, height: 3.0)
        
        // Create material with better visibility
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(color)
        material.emission.contents = UIColor(color).withAlphaComponent(0.8)
        material.specular.contents = UIColor.white
        material.shininess = 1.0
        lightningGeometry.materials = [material]
        
        lightningNode.geometry = lightningGeometry
        lightningNode.position = SCNVector3(0, 0, 0)
        lightningNode.scale = SCNVector3(1, 1, 1)
        
        // Add electric flicker animation
        let flickerAction = SCNAction.sequence([
            SCNAction.fadeOpacity(to: 0.4, duration: 0.2),
            SCNAction.fadeOpacity(to: 1.0, duration: 0.2)
        ])
        lightningNode.runAction(SCNAction.repeatForever(flickerAction))
        
        return lightningNode
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
        // Update animation speeds by recreating animations with adjusted duration
        guard let modelNode = modelNode else { return }
        
        // Remove existing animations
        modelNode.removeAllActions()
        modelNode.enumerateChildNodes { node, _ in
            node.removeAllActions()
        }
        
        // Recreate animations with new speed
        let speedMultiplier = speed > 0 ? 1.0 / speed : 1.0
        
        switch currentModelType {
        case .heart:
            recreateHeartAnimation(modelNode: modelNode, speedMultiplier: speedMultiplier)
        case .sparkles:
            recreateSparklesAnimation(modelNode: modelNode, speedMultiplier: speedMultiplier)
        case .lightning:
            recreateLightningAnimation(modelNode: modelNode, speedMultiplier: speedMultiplier)
        }
    }
    
    private func recreateHeartAnimation(modelNode: SCNNode, speedMultiplier: Float) {
        let pulseAction = SCNAction.sequence([
            SCNAction.scale(to: 1.2, duration: 0.5 * Double(speedMultiplier)),
            SCNAction.scale(to: 1.0, duration: 0.5 * Double(speedMultiplier))
        ])
        modelNode.runAction(SCNAction.repeatForever(pulseAction))
    }
    
    private func recreateSparklesAnimation(modelNode: SCNNode, speedMultiplier: Float) {
        // Recreate sparkle animations for existing child nodes
        modelNode.childNodes.forEach { sparkle in
            let rotateAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(Float.pi) * 2, duration: 2.0 * Double(speedMultiplier))
            sparkle.runAction(SCNAction.repeatForever(rotateAction))
        }
        
        // Recreate orbital animation
        let orbitAction = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(Float.pi) * 2, duration: 4.0 * Double(speedMultiplier))
        modelNode.runAction(SCNAction.repeatForever(orbitAction))
    }
    
    private func recreateLightningAnimation(modelNode: SCNNode, speedMultiplier: Float) {
        let flickerAction = SCNAction.sequence([
            SCNAction.fadeOpacity(to: 0.3, duration: 0.1 * Double(speedMultiplier)),
            SCNAction.fadeOpacity(to: 1.0, duration: 0.1 * Double(speedMultiplier))
        ])
        modelNode.runAction(SCNAction.repeatForever(flickerAction))
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
