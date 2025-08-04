//
//  USDZTestView.swift
//  model-tranform-controls
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI
import SceneKit

struct USDZTestView: View {
    @State private var debugInfo: [String] = []
    @State private var isTesting = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("USDZ Loading Debug")
                    .font(.title)
                    .fontWeight(.bold)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(debugInfo, id: \.self) { info in
                            Text(info)
                                .font(.system(.body, design: .monospaced))
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(4)
                        }
                    }
                    .padding()
                }
                
                Button(action: runDebugTest) {
                    HStack {
                        if isTesting {
                            ProgressView()
                                .scaleEffect(0.8)
                        }
                        Text(isTesting ? "Testing..." : "Run Debug Test")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isTesting)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func runDebugTest() {
        isTesting = true
        debugInfo.removeAll()
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Test 1: Check bundle contents
            addDebugInfo("🔍 Checking Bundle Contents...")
            
            let bundlePath = Bundle.main.bundlePath
            addDebugInfo("Bundle Path: \(bundlePath)")
            
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: bundlePath)
                addDebugInfo("Bundle Contents: \(contents)")
            } catch {
                addDebugInfo("❌ Error reading bundle: \(error)")
            }
            
            // Test 2: Check for USDZ file in subdirectory
            addDebugInfo("\n🔍 Testing USDZ in subdirectory...")
            
            if let modelURL = Bundle.main.url(forResource: "heart_model", withExtension: "usdz", subdirectory: "Models/3d_models") {
                addDebugInfo("✅ Found USDZ at: \(modelURL.path)")
                
                // Test if file exists
                if FileManager.default.fileExists(atPath: modelURL.path) {
                    addDebugInfo("✅ File exists at path")
                    
                    // Test file size
                    do {
                        let attributes = try FileManager.default.attributesOfItem(atPath: modelURL.path)
                        if let fileSize = attributes[.size] as? Int64 {
                            addDebugInfo("📏 File size: \(fileSize) bytes")
                        }
                    } catch {
                        addDebugInfo("❌ Error getting file attributes: \(error)")
                    }
                    
                    // Test loading USDZ
                    do {
                        let scene = try SCNScene(url: modelURL, options: [
                            .convertToYUp: true,
                            .convertUnitsToMeters: true
                        ])
                        addDebugInfo("✅ Successfully loaded USDZ scene")
                        addDebugInfo("📊 Scene root node children: \(scene.rootNode.childNodes.count)")
                        
                        // Check for geometry
                        var geometryCount = 0
                        scene.rootNode.enumerateChildNodes { node, _ in
                            if node.geometry != nil {
                                geometryCount += 1
                            }
                        }
                        addDebugInfo("📐 Nodes with geometry: \(geometryCount)")
                        
                    } catch {
                        addDebugInfo("❌ Error loading USDZ scene: \(error)")
                    }
                    
                } else {
                    addDebugInfo("❌ File does not exist at path")
                }
            } else {
                addDebugInfo("❌ Could not find USDZ file in subdirectory")
            }
            
            // Test 3: Check for USDZ file in bundle root
            addDebugInfo("\n🔍 Testing USDZ in bundle root...")
            
            if let modelURL = Bundle.main.url(forResource: "heart_model", withExtension: "usdz") {
                addDebugInfo("✅ Found USDZ at root: \(modelURL.path)")
                
                if FileManager.default.fileExists(atPath: modelURL.path) {
                    addDebugInfo("✅ File exists at root path")
                } else {
                    addDebugInfo("❌ File does not exist at root path")
                }
            } else {
                addDebugInfo("❌ Could not find USDZ file in bundle root")
            }
            
            // Test 4: Check for SCN file
            addDebugInfo("\n🔍 Testing SCN file...")
            
            if let modelURL = Bundle.main.url(forResource: "heart_model", withExtension: "scn", subdirectory: "Models/3d_models") {
                addDebugInfo("✅ Found SCN at: \(modelURL.path)")
                
                if FileManager.default.fileExists(atPath: modelURL.path) {
                    addDebugInfo("✅ SCN file exists")
                    
                    do {
                        let scene = try SCNScene(url: modelURL, options: nil)
                        addDebugInfo("✅ Successfully loaded SCN scene")
                        addDebugInfo("📊 SCN root node children: \(scene.rootNode.childNodes.count)")
                    } catch {
                        addDebugInfo("❌ Error loading SCN scene: \(error)")
                    }
                } else {
                    addDebugInfo("❌ SCN file does not exist")
                }
            } else {
                addDebugInfo("❌ Could not find SCN file")
            }
            
            // Test 5: List all resources
            addDebugInfo("\n🔍 Listing all bundle resources...")
            
            if let resources = Bundle.main.urls(forResourcesWithExtension: nil, subdirectory: nil) {
                addDebugInfo("📦 Total resources: \(resources.count)")
                
                let usdzFiles = resources.filter { $0.pathExtension == "usdz" }
                let scnFiles = resources.filter { $0.pathExtension == "scn" }
                
                addDebugInfo("📦 USDZ files: \(usdzFiles.count)")
                addDebugInfo("📦 SCN files: \(scnFiles.count)")
                
                for usdz in usdzFiles {
                    addDebugInfo("  - \(usdz.lastPathComponent)")
                }
                
                for scn in scnFiles {
                    addDebugInfo("  - \(scn.lastPathComponent)")
                }
            }
            
            DispatchQueue.main.async {
                self.isTesting = false
            }
        }
    }
    
    private func addDebugInfo(_ info: String) {
        DispatchQueue.main.async {
            self.debugInfo.append(info)
        }
    }
}

struct USDZTestView_Previews: PreviewProvider {
    static var previews: some View {
        USDZTestView()
    }
} 