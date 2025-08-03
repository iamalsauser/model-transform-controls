//
//  SCNNode+Extensions.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SceneKit
import SwiftUI

extension SCNNode {
    // MARK: - Convenience Initializers
    convenience init(geometry: SCNGeometry, material: SCNMaterial) {
        self.init()
        self.geometry = geometry
        self.geometry?.materials = [material]
    }
    
    convenience init(geometry: SCNGeometry, color: Color) {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(color)
        self.init(geometry: geometry, material: material)
    }
    
    // MARK: - Transform Helpers
    func setPosition(_ x: Float, _ y: Float, _ z: Float) {
        position = SCNVector3(x, y, z)
    }
    
    func setRotation(_ x: Float, _ y: Float, _ z: Float) {
        eulerAngles = SCNVector3(x, y, z)
    }
    
    func setScale(_ x: Float, _ y: Float, _ z: Float) {
        scale = SCNVector3(x, y, z)
    }
    
    func setScale(_ uniform: Float) {
        scale = SCNVector3(uniform, uniform, uniform)
    }
    
    // MARK: - Animation Helpers
    func addPulseAnimation(duration: TimeInterval = 1.0, scale: Float = 1.2) {
        let pulseAction = SCNAction.sequence([
            SCNAction.scale(to: CGFloat(scale), duration: duration / 2),
            SCNAction.scale(to: 1.0, duration: duration / 2)
        ])
        runAction(SCNAction.repeatForever(pulseAction))
    }
    
    func addRotationAnimation(duration: TimeInterval = 2.0, axis: SCNVector3 = SCNVector3(0, 0, 1)) {
        let rotationAction = SCNAction.rotateBy(x: CGFloat(axis.x), y: CGFloat(axis.y), z: CGFloat(axis.z), duration: duration)
        runAction(SCNAction.repeatForever(rotationAction))
    }
    
    func addFlickerAnimation(duration: TimeInterval = 0.2) {
        let flickerAction = SCNAction.sequence([
            SCNAction.fadeOpacity(to: 0.3, duration: duration),
            SCNAction.fadeOpacity(to: 1.0, duration: duration)
        ])
        runAction(SCNAction.repeatForever(flickerAction))
    }
    
    // MARK: - Material Helpers
    func setMaterialColor(_ color: Color) {
        geometry?.materials.forEach { material in
            material.diffuse.contents = UIColor(color)
        }
    }
    
    func setMaterialEmission(_ color: Color, intensity: CGFloat = 0.3) {
        geometry?.materials.forEach { material in
            material.emission.contents = UIColor(color).withAlphaComponent(intensity)
        }
    }
    
    func setMaterialTransparency(_ alpha: CGFloat) {
        geometry?.materials.forEach { material in
            material.transparency = alpha
        }
    }
    
    // MARK: - Child Node Helpers
    func addChildNodes(_ nodes: [SCNNode]) {
        nodes.forEach { addChildNode($0) }
    }
    
    func removeAllChildNodes() {
        childNodes.forEach { $0.removeFromParentNode() }
    }
    
    // MARK: - Utility Methods
    func distance(to node: SCNNode) -> Float {
        let dx = position.x - node.position.x
        let dy = position.y - node.position.y
        let dz = position.z - node.position.z
        return sqrt(dx * dx + dy * dy + dz * dz)
    }
    
    func lookAt(_ target: SCNNode) {
        let direction = SCNVector3(
            target.position.x - position.x,
            target.position.y - position.y,
            target.position.z - position.z
        )
        
        let length = sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z)
        if length > 0 {
            let normalizedDirection = SCNVector3(direction.x / length, direction.y / length, direction.z / length)
            let rotationMatrix = SCNMatrix4MakeRotation(0, normalizedDirection.x, normalizedDirection.y, normalizedDirection.z)
            transform = rotationMatrix
        }
    }
} 
