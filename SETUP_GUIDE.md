# Flam Post Builder - Setup Guide

## 🚀 Quick Start

### Prerequisites
- **Xcode 15.0+** (latest version recommended)
- **iOS 16.0+** Simulator or Device
- **macOS 13.0+**

### Running the App

1. **Open the Project**
   ```bash
   open model-tranform-controls.xcodeproj
   ```

2. **Select Target Device**
   - Choose iOS Simulator (iPhone 15 recommended)
   - Or connect your iOS device

3. **Build and Run**
   - Press `⌘ + R` or click the Play button
   - Wait for the app to build and launch

## 🎯 What You'll See

### Main Interface
- **Beautiful gradient background** (purple to blue)
- **3D Preview area** on the left with real-time SceneKit rendering
- **Control panels** on the right for content creation

### Interactive Features
1. **Caption Input**: Type your post text (max 280 characters)
2. **Model Selection**: Choose from Heart 💖, Sparkles ✨, or Lightning ⚡
3. **Color Picker**: 6 preset colors to customize your 3D model
4. **Transform Controls**: 
   - Rotation slider (0-360°)
   - Scale slider (0.5x - 2.0x)
   - Animation speed (0-3x)
   - Live/Pause toggle
5. **Create Post**: Simulates post creation with success feedback

### 3D Models
- **Heart**: Pulsing animation with glow effects
- **Sparkles**: Orbital particle system with rotating stars
- **Lightning**: Electric flicker animation

## 🔧 Technical Architecture

### File Structure
```
model-tranform-controls/
├── Models/
│   ├── PostModel.swift          # Data structures
│   └── SceneModel.swift         # 3D scene management
├── ViewModels/
│   └── PostBuilderViewModel.swift # State management
├── Views/
│   ├── PostBuilderView.swift    # Main interface
│   ├── SceneKitView.swift       # 3D rendering bridge
│   └── Components/              # Reusable UI components
├── Extensions/                  # Utility extensions
└── App files
```

### Key Components
- **SwiftUI**: Native UI layer
- **SceneKit**: 3D rendering (replaceable with Unreal)
- **Combine**: Reactive state management
- **MVVM**: Clean architecture pattern

## 🎤 Interview Demo Flow

### 1. Architecture Discussion
> "This demonstrates the exact architecture Flam would use - SwiftUI handles the native UI layer while SceneKit manages 3D content. The `UIViewRepresentable` bridge is where you'd integrate Unreal Engine in production."

### 2. Live Demo Steps
1. **Show the interface**: "Here's our Flam Post Builder prototype"
2. **Demonstrate 3D interaction**: Adjust rotation, scale, animation speed
3. **Switch models**: Show different 3D models and their animations
4. **Change colors**: Demonstrate real-time color updates
5. **Create a post**: Show the complete workflow

### 3. Technical Highlights
- **Real-time UI ↔ 3D sync**: Changes in UI immediately reflect in 3D
- **Smooth animations**: 60fps SceneKit rendering
- **Responsive design**: Works on different screen sizes
- **Modern UI**: Glassmorphism design with gradients

## 🐛 Troubleshooting

### Common Issues

**Build Errors**
- Ensure Xcode 15.0+ is installed
- Clean build folder: `⌘ + Shift + K`
- Reset package caches if needed

**Simulator Issues**
- Reset simulator: Device → Erase All Content and Settings
- Try different simulator devices

**3D Rendering Issues**
- Check that SceneKit is properly imported
- Verify device supports Metal (iOS 8+)

### Performance Tips
- Use iOS Simulator for development
- Test on physical device for best 3D performance
- Monitor memory usage with large 3D scenes

## 📱 Testing Checklist

### Basic Functionality
- [ ] App launches without crashes
- [ ] 3D preview renders correctly
- [ ] Model switching works
- [ ] Color changes are applied
- [ ] Transform controls respond
- [ ] Caption input works
- [ ] Create post button functions

### Advanced Features
- [ ] Real-time UI updates
- [ ] Smooth animations
- [ ] Camera controls work
- [ ] Responsive layout
- [ ] Error handling

## 🎯 Success Criteria

The app should demonstrate:
1. **Professional UI/UX**: Modern, polished interface
2. **Technical Excellence**: Clean, maintainable code
3. **Real-time Integration**: SwiftUI ↔ SceneKit bridge
4. **Product Understanding**: Flam's core functionality
5. **Scalability**: Architecture ready for Unreal integration

## 🚀 Next Steps

### For Production
- Replace SceneKit with Unreal Engine
- Add AR support with RealityKit
- Integrate with backend APIs
- Add user authentication
- Implement social features

### For Interview
- Prepare talking points about architecture
- Practice live demo flow
- Have backup plans for technical issues
- Know the codebase well enough to explain any part

---

**Good luck with your Flam interview! 🎉** 