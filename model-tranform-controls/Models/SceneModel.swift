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
    }
    
    private func setupScene() {
        // Add root node to scene
        scene.rootNode.addChildNode(rootNode)
        
        // Setup camera
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5)
        rootNode.addChildNode(cameraNode)
        
        // Add ambient lighting
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 100
        rootNode.addChildNode(ambientLight)
        
        // Add directional lighting
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 800
        directionalLight.position = SCNVector3(5, 5, 5)
        directionalLight.eulerAngles = SCNVector3(-Float.pi/4, Float.pi/4, 0)
        rootNode.addChildNode(directionalLight)
    }
    
    func updateModel(_ modelType: ModelType, color: Color) {
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
        }
    }
    
    private func createHeartModel(color: Color) -> SCNNode {
        let heartNode = SCNNode()
        
        // Create heart geometry using custom shape
        let heartPath = UIBezierPath()
        heartPath.move(to: CGPoint(x: 0, y: 0.5))
        heartPath.addCurve(to: CGPoint(x: -1, y: -0.5),
                          controlPoint1: CGPoint(x: -0.5, y: 0.5),
                          controlPoint2: CGPoint(x: -1, y: 0))
        heartPath.addCurve(to: CGPoint(x: 0, y: -1.5),
                          controlPoint1: CGPoint(x: -1, y: -1),
                          controlPoint2: CGPoint(x: -0.5, y: -1.5))
        heartPath.addCurve(to: CGPoint(x: 1, y: -0.5),
                          controlPoint1: CGPoint(x: 0.5, y: -1.5),
                          controlPoint2: CGPoint(x: 1, y: -1))
        heartPath.addCurve(to: CGPoint(x: 0, y: 0.5),
                          controlPoint1: CGPoint(x: 1, y: 0),
                          controlPoint2: CGPoint(x: 0.5, y: 0.5))
        
        let heartShape = SCNShape(path: heartPath, extrusionDepth: 0.1)
        let heartGeometry = heartShape
        
        // Create material
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(color)
        material.emission.contents = UIColor(color).withAlphaComponent(0.3)
        material.transparency = 0.9
        heartGeometry.materials = [material]
        
        heartNode.geometry = heartGeometry
        heartNode.scale = SCNVector3(1, 1, 1)
        
        // Add pulse animation
        let pulseAction = SCNAction.sequence([
            SCNAction.scale(to: 1.2, duration: 0.5),
            SCNAction.scale(to: 1.0, duration: 0.5)
        ])
        heartNode.runAction(SCNAction.repeatForever(pulseAction))
        
        return heartNode
    }
    
    private func createSparklesModel(color: Color) -> SCNNode {
        let sparklesNode = SCNNode()
        
        // Create multiple sparkle particles
        for i in 0..<8 {
            let sparkle = SCNNode()
            
            // Create star geometry
            let starGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor(color)
            material.emission.contents = UIColor(color).withAlphaComponent(0.5)
            starGeometry.materials = [material]
            
            sparkle.geometry = starGeometry
            
            // Position in circle
            let angle = Float(i) * Float.pi * 2 / 8
            let radius: Float = 1.0
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
        
        // Create lightning bolt geometry
        let lightningPath = UIBezierPath()
        lightningPath.move(to: CGPoint(x: 0, y: 1))
        lightningPath.addLine(to: CGPoint(x: -0.3, y: 0.3))
        lightningPath.addLine(to: CGPoint(x: 0.2, y: 0))
        lightningPath.addLine(to: CGPoint(x: -0.1, y: -0.4))
        lightningPath.addLine(to: CGPoint(x: 0, y: -1))
        
        let lightningShape = SCNShape(path: lightningPath, extrusionDepth: 0.05)
        let lightningGeometry = lightningShape
        
        // Create material
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(color)
        material.emission.contents = UIColor(color).withAlphaComponent(0.7)
        material.transparency = 0.8
        lightningGeometry.materials = [material]
        
        lightningNode.geometry = lightningGeometry
        lightningNode.scale = SCNVector3(1, 1, 1)
        
        // Add electric flicker animation
        let flickerAction = SCNAction.sequence([
            SCNAction.fadeOpacity(to: 0.3, duration: 0.1),
            SCNAction.fadeOpacity(to: 1.0, duration: 0.1)
        ])
        lightningNode.runAction(SCNAction.repeatForever(flickerAction))
        
        return lightningNode
    }
    
    func updateTransform(rotation: Float, scale: Float) {
        modelNode?.eulerAngles.z = rotation * Float.pi / 180
        modelNode?.scale = SCNVector3(scale, scale, scale)
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
        // Recreate sparkle animations
        for (_, sparkle) in modelNode.childNodes.enumerated() {
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
