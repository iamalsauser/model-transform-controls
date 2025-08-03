# Flam Post Builder - iOS Demo

A sophisticated iOS demo showcasing SwiftUI + 3D integration, designed to demonstrate the architecture that would be used for Flam's Unreal Engine + SwiftUI integration.

## 🎯 Project Overview

This demo mimics Flam's core functionality - creating immersive social posts with 3D content. It demonstrates:

- **SwiftUI** for native UI layer
- **SceneKit** for 3D rendering (replaceable with Unreal Engine)
- **MVVM Architecture** for clean state management
- **Real-time UI ↔ 3D synchronization**

## 🏗️ Architecture

### Core Technologies
- **SwiftUI**: Native UI components and state management
- **SceneKit**: 3D rendering engine (production would use Unreal)
- **Combine**: Reactive state management
- **MVVM Pattern**: Clean separation of concerns

### Key Components

```
FlamPostBuilder/
├── App/
│   ├── FlamPostBuilderApp.swift      # App entry point
│   └── ContentView.swift             # Root view
├── Views/
│   ├── PostBuilderView.swift         # Main interface
│   ├── SceneKitView.swift            # 3D rendering bridge
│   └── Components/
│       ├── ModelSelectorView.swift   # 3D model selection
│       ├── TransformControlsView.swift # Real-time transforms
│       ├── CaptionInputView.swift    # Text input
│       └── ColorPickerView.swift     # Color selection
├── Models/
│   ├── PostModel.swift               # Data structure
│   └── SceneModel.swift              # 3D scene management
├── ViewModels/
│   └── PostBuilderViewModel.swift    # State management
└── Extensions/
    ├── Color+Extensions.swift        # Color utilities
    └── SCNNode+Extensions.swift      # 3D node helpers
```

## 🚀 Features

### 3D Models
- **💖 Heart**: Pulsing animation with glow effects
- **✨ Sparkles**: Orbital particle system
- **⚡ Lightning**: Electric flicker animation

### Interactive Controls
- **Real-time rotation** (0-360°)
- **Dynamic scaling** (0.5x - 2.0x)
- **Animation speed control** (0-3x)
- **Live/pause toggle**
- **Color customization**

### UI Features
- **Character-limited caption input** (280 chars)
- **Real-time 3D preview**
- **Responsive design**
- **Modern glassmorphism UI**

## 🎤 Interview Talking Points

### Architecture Discussion
> "This demonstrates the exact architecture Flam would use - SwiftUI handles the native UI layer while SceneKit manages 3D content. The `UIViewRepresentable` bridge is where you'd integrate Unreal Engine in production."

### Scalability
> "The ViewModel pattern makes it easy to swap rendering backends. This same state management would work with Unreal's C++ bridge or RealityKit for AR features."

### Product Understanding
> "I built this as a prototype of Flam's core user flow - creating immersive social posts. The content creation workflow mirrors what users would expect from a social AR platform."

## 🔧 Technical Implementation

### SwiftUI + SceneKit Bridge
```swift
struct SceneKitView: UIViewRepresentable {
    @ObservedObject var viewModel: PostBuilderViewModel
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = viewModel.sceneModel.scene
        sceneView.allowsCameraControl = true
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update 3D scene based on SwiftUI state
        updateModelTransform(uiView, viewModel: viewModel)
    }
}
```

### State Management
```swift
@MainActor
class PostBuilderViewModel: ObservableObject {
    @Published var caption: String = ""
    @Published var selectedModel: ModelType = .heart
    @Published var modelColor: Color = .red
    @Published var rotation: Float = 0
    @Published var scale: Float = 1.0
    @Published var animationSpeed: Float = 1.0
    @Published var isAnimating: Bool = true
}
```

### Animation System
- **SCNAction** for model animations
- **Combine publishers** for real-time UI updates
- **CADisplayLink** for smooth 60fps updates

## 🎨 UI/UX Design

### Design Principles
- **Glassmorphism**: Translucent backgrounds with blur effects
- **Gradient backgrounds**: Purple to blue gradients
- **Consistent spacing**: 16px base unit system
- **Interactive feedback**: Hover states and animations

### Color Scheme
- **Primary**: Purple (#9333EA)
- **Secondary**: Pink (#EC4899)
- **Accent**: Blue (#3B82F6)
- **Background**: Dark gradients with transparency

## 📱 Requirements

- **iOS 16.0+**
- **Xcode 15.0+**
- **Swift 5.9+**

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd model-tranform-controls
   ```

2. **Open in Xcode**
   ```bash
   open model-tranform-controls.xcodeproj
   ```

3. **Build and Run**
   - Select iOS Simulator or device
   - Press ⌘+R to build and run

## 🎯 Demo Flow

1. **Caption Input**: Enter post text (max 280 characters)
2. **Model Selection**: Choose from Heart, Sparkles, or Lightning
3. **Color Customization**: Pick from 6 preset colors
4. **Transform Controls**: Adjust rotation, scale, and animation speed
5. **Real-time Preview**: See changes instantly in 3D view
6. **Create Post**: Simulate post creation with success feedback

## 🔮 Future Enhancements

### For Production
- **Unreal Engine Integration**: Replace SceneKit with Unreal via UIViewRepresentable
- **AR Support**: RealityKit integration for AR features
- **Backend Integration**: Real post creation and sharing
- **Asset Management**: 3D model library and customization

### Additional Features
- **Particle Systems**: More complex visual effects
- **Audio Integration**: Sound effects and music
- **Social Features**: Like, comment, share functionality
- **Analytics**: User interaction tracking

## 📄 License

This project is created for demonstration purposes as part of the Flam interview process.

## 🤝 Contributing

This is a demo project created for interview purposes. For questions or feedback, please reach out to the development team.

---

**Built with ❤️ for Flam's iOS Engineering Team**
