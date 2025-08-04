import SwiftUI
import RealityKit
import Combine

struct RealityKitUSDZViewer: View {
    @State private var isModelLoaded = false
    @State private var loadingError: String?
    @State private var modelScale: Float = 1.0
    @State private var modelRotation: Float = 0.0
    @State private var modelXRotation: Float = 0.0
    @State private var cameraDistance: Float = 5.0  // Reduced from 10.0
    
    @State private var showControls = false
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            // Full-screen 3D Model View with drag gesture
            RealityKitUSDZView(
                isModelLoaded: $isModelLoaded,
                loadingError: $loadingError,
                modelScale: $modelScale,
                modelRotation: $modelRotation,
                modelXRotation: $modelXRotation,
                cameraDistance: $cameraDistance
            )
            .edgesIgnoringSafeArea(.all)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Horizontal drag affects Y-axis rotation
                        modelRotation += Float(value.translation.width - dragOffset.width) * 0.5
                        // Vertical drag affects X-axis rotation
                        modelXRotation += Float(value.translation.height - dragOffset.height) * 0.5
                        dragOffset = value.translation
                    }
                    .onEnded { _ in
                        dragOffset = .zero
                    }
            )
            
            // Controls overlay
            VStack {
                HStack {
                    Spacer()
                    
                    // Toggle button for controls
                    Button(action: {
                        withAnimation(.spring()) {
                            showControls.toggle()
                        }
                    }) {
                        Image(systemName: showControls ? "xmark.circle.fill" : "slider.horizontal.3")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                if showControls {
                    VStack(spacing: 16) {
                        // Scale Control
                        ControlSlider(
                            title: "Scale",
                            value: $modelScale,
                            range: 0.1...3.0,
                            step: 0.1,
                            format: "%.1fx",
                            color: .blue
                        )
                        
                        // Y Rotation Control
                        ControlSlider(
                            title: "Y Rotation",
                            value: $modelRotation,
                            range: 0...360,
                            step: 1,
                            format: "%.0f°",
                            color: .purple
                        )
                        
                        // X Rotation Control
                        ControlSlider(
                            title: "X Rotation",
                            value: $modelXRotation,
                            range: -90...90,
                            step: 1,
                            format: "%.0f°",
                            color: .green
                        )
                        
                        // Zoom Control
                        ControlSlider(
                            title: "Zoom",
                            value: $cameraDistance,
                            range: 1.0...100.0,  // Adjusted range
                            step: 0.5,
                            format: "%.1f",
                            color: .orange
                        )
                        
                        // Reset Button
                        Button(action: {
                            withAnimation {
                                modelScale = 1.0
                                modelRotation = 0.0
                                modelXRotation = 0.0
                                cameraDistance = 5.0  // Reset to new default
                            }
                        }) {
                            Text("Reset View")
                                .frame(maxWidth: .infinity)
                                .padding(8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 20)
                }
            }
            
            // Loading status
            if !isModelLoaded {
                VStack {
                    Spacer()
                    
                    if let error = loadingError {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    } else {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct ControlSlider: View {
    let title: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    let step: Float
    let format: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text(String(format: format, value))
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Slider(value: $value, in: range, step: step)
                .accentColor(color)
        }
    }
}

struct RealityKitUSDZView: UIViewRepresentable {
    @Binding var isModelLoaded: Bool
    @Binding var loadingError: String?
    @Binding var modelScale: Float
    @Binding var modelRotation: Float
    @Binding var modelXRotation: Float
    @Binding var cameraDistance: Float
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        context.coordinator.arView = arView
        
        arView.backgroundColor = UIColor.systemBackground
        loadUSDZModel(arView: arView, coordinator: context.coordinator)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        let coordinator = context.coordinator
        
        if let modelEntity = coordinator.modelEntity {
            modelEntity.scale = [modelScale, modelScale, modelScale]
            
            let yRotation = simd_quatf(angle: modelRotation * Float.pi / 180.0, axis: [0, 1, 0])
            let xRotation = simd_quatf(angle: modelXRotation * Float.pi / 180.0, axis: [1, 0, 0])
            modelEntity.orientation = yRotation * xRotation
        }
        
        if let modelAnchor = coordinator.modelAnchor {
            let zPosition = -cameraDistance + 5.0  // Changed from +10.0 to +5.0
            modelAnchor.transform.translation.z = zPosition
        }
    }
    
    class Coordinator: NSObject {
        var parent: RealityKitUSDZView
        var arView: ARView?
        var modelEntity: ModelEntity?
        var modelAnchor: AnchorEntity?
        var cancellables: Set<AnyCancellable> = []
        
        init(_ parent: RealityKitUSDZView) {
            self.parent = parent
        }
    }
    
    private func loadUSDZModel(arView: ARView, coordinator: Coordinator) {
        let modelPath = "/Users/parthsinh/Documents/Flam/model-tranform-controls/model-tranform-controls/Models/3d_models/Free_Base_Mesh.usdz"
        
        if FileManager.default.fileExists(atPath: modelPath) {
            let modelURL = URL(fileURLWithPath: modelPath)
            loadModelFromURL(modelURL, arView: arView, coordinator: coordinator)
            return
        }
        
        if let modelURL = Bundle.main.url(forResource: "Free_Base_Mesh", withExtension: "usdz", subdirectory: "Models/3d_models") {
            loadModelFromURL(modelURL, arView: arView, coordinator: coordinator)
            return
        }
        
        if let modelURL = Bundle.main.url(forResource: "Free_Base_Mesh", withExtension: "usdz") {
            loadModelFromURL(modelURL, arView: arView, coordinator: coordinator)
            return
        }
        
        createFallbackModel(arView: arView, coordinator: coordinator)
        DispatchQueue.main.async {
            self.isModelLoaded = true
            self.loadingError = "USDZ file not found - using fallback model"
        }
    }
    
    private func loadModelFromURL(_ url: URL, arView: ARView, coordinator: Coordinator) {
        ModelEntity.loadModelAsync(contentsOf: url)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak coordinator] completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.loadingError = "Failed to load USDZ: \(error.localizedDescription)"
                            self.createFallbackModel(arView: arView, coordinator: coordinator)
                        }
                    }
                },
                receiveValue: { [weak coordinator] modelEntity in
                    guard let coordinator = coordinator else { return }
                    
                    let anchor = AnchorEntity()
                    anchor.addChild(modelEntity)
                    arView.scene.addAnchor(anchor)
                    
                    coordinator.modelEntity = modelEntity
                    coordinator.modelAnchor = anchor
                    
                    let bounds = modelEntity.visualBounds(relativeTo: anchor)
                    let center = bounds.center
                    // Shift model down by 1.5 units
                    modelEntity.position = [-center.x, -center.y - 1.5, -center.z]
                    
                    // Adjusted camera position
                    let zPosition = -coordinator.parent.cameraDistance + 5.0
                    anchor.transform.translation.z = zPosition
                    
                    DispatchQueue.main.async {
                        self.isModelLoaded = true
                        self.loadingError = nil
                    }
                }
            )
            .store(in: &coordinator.cancellables)
    }
    
    private func createFallbackModel(arView: ARView, coordinator: Coordinator?) {
        let mesh = MeshResource.generateSphere(radius: 0.5)
        let material = SimpleMaterial(color: .systemRed, roughness: 0.3, isMetallic: false)
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        let anchor = AnchorEntity()
        anchor.addChild(modelEntity)
        arView.scene.addAnchor(anchor)
        
        // Position fallback model lower
        modelEntity.position = [0, -1.5, 0]
        
        coordinator?.modelEntity = modelEntity
        coordinator?.modelAnchor = anchor
        
        if let coordinator = coordinator {
            let zPosition = -coordinator.parent.cameraDistance + 5.0
            anchor.transform.translation.z = zPosition
        }
        
        DispatchQueue.main.async {
            self.isModelLoaded = true
        }
    }
}
