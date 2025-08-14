import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlFile: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        // Create WKWebView configuration
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // Enable WebGL and hardware acceleration
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        configuration.defaultWebpagePreferences = preferences
        
        // Add script message handler
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "iosNative")
        configuration.userContentController = contentController
        
        // Create WKWebView with configuration
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .clear
        webView.isOpaque = false
        webView.scrollView.bounces = false
        webView.scrollView.isScrollEnabled = false // Disable scrolling
        webView.navigationDelegate = context.coordinator // Set navigation delegate
        
        // Configure WebView for optimal 3D rendering
        webView.configuration.preferences.javaScriptEnabled = true
        
        // Load local HTML file
        if let htmlPath = Bundle.main.path(forResource: htmlFile, ofType: "html"),
           let htmlString = try? String(contentsOfFile: htmlPath, encoding: .utf8) {
            // Use local file URL to ensure proper resource loading
            if let baseURL = Bundle.main.url(forResource: htmlFile, withExtension: "html"),
               let bundleURL = Bundle.main.resourceURL {
                // Allow access to the entire bundle for model loading
                webView.loadFileURL(baseURL, allowingReadAccessTo: bundleURL)
            } else {
                // Fallback to loadHTMLString if file URL fails
                webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
            }
            print("Attempting to load HTML file from: \(htmlPath)")
        } else {
            print("Failed to load HTML file: \(htmlFile).html")
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Updates can be handled here if needed
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("WebView finished loading")
            
            // Inject debug logging
            let debug = """
                console.log('Debug: Starting detailed initialization check...');
                
                // Override console methods to relay to iOS
                const originalConsole = {
                    log: console.log,
                    error: console.error,
                    warn: console.warn
                };
                
                // Function to check WebGL compatibility
                function checkWebGLCompatibility() {
                    const canvas = document.createElement('canvas');
                    try {
                        const gl = canvas.getContext('webgl2') || canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
                        if (!gl) {
                            throw new Error('WebGL not supported');
                        }
                        return {
                            supported: true,
                            version: gl.getParameter(gl.VERSION),
                            vendor: gl.getParameter(gl.VENDOR),
                            renderer: gl.getParameter(gl.RENDERER)
                        };
                    } catch (e) {
                        return { supported: false, error: e.message };
                    }
                }
                
                // Function to check Three.js scene status
                function checkSceneStatus() {
                    return {
                        threeJS: typeof THREE !== 'undefined',
                        scene: typeof scene !== 'undefined' ? {
                            exists: true,
                            children: scene?.children?.length || 0,
                            background: scene?.background ? true : false,
                            fog: scene?.fog ? true : false
                        } : { exists: false },
                        camera: typeof camera !== 'undefined' ? {
                            exists: true,
                            type: camera.type,
                            position: camera.position.toArray()
                        } : { exists: false },
                        renderer: typeof renderer !== 'undefined' ? {
                            exists: true,
                            domElement: renderer.domElement ? true : false,
                            size: renderer.getSize ? renderer.getSize(new THREE.Vector2()).toArray() : null
                        } : { exists: false }
                    };
                }
                
                console.log = function() {
                    originalConsole.log.apply(console, arguments);
                    window.webkit.messageHandlers.iosNative.postMessage({
                        type: 'log',
                        message: Array.from(arguments).join(' ')
                    });
                };
                
                console.error = function() {
                    originalConsole.error.apply(console, arguments);
                    window.webkit.messageHandlers.iosNative.postMessage({
                        type: 'error',
                        message: Array.from(arguments).join(' ')
                    });
                };
                
                console.warn = function() {
                    originalConsole.warn.apply(console, arguments);
                    window.webkit.messageHandlers.iosNative.postMessage({
                        type: 'warning',
                        message: Array.from(arguments).join(' ')
                    });
                };
                
                // Check WebGL compatibility
                const webglStatus = checkWebGLCompatibility();
                window.webkit.messageHandlers.iosNative.postMessage({
                    type: 'webgl-status',
                    status: webglStatus
                });

                // Check Three.js and scene status
                const sceneStatus = checkSceneStatus();
                window.webkit.messageHandlers.iosNative.postMessage({
                    type: 'scene-status',
                    status: sceneStatus
                });
                
                // Add DOM structure check
                const container = document.getElementById('container');
                window.webkit.messageHandlers.iosNative.postMessage({
                    type: 'dom-status',
                    status: {
                        container: container ? {
                            exists: true,
                            size: {
                                width: container.clientWidth,
                                height: container.clientHeight
                            },
                            children: container.children.length,
                            hasCanvas: container.querySelector('canvas') ? true : false
                        } : { exists: false }
                    }
                });
                
                // Add resize observer to monitor container size
                if (container) {
                    new ResizeObserver(entries => {
                        window.webkit.messageHandlers.iosNative.postMessage({
                            type: 'container-resize',
                            size: {
                                width: entries[0].contentRect.width,
                                height: entries[0].contentRect.height
                            }
                        });
                    }).observe(container);
                }

                // Initialize Three.js scene if not already initialized
                if (typeof scene === 'undefined') {
                    try {
                        console.log('Initializing Three.js scene...');
                        
                        // Create scene
                        window.scene = new THREE.Scene();
                        scene.background = new THREE.Color(0x667eea);
                        scene.fog = new THREE.Fog(0x667eea, 50, 100);

                        // Create camera
                        const aspect = window.innerWidth / window.innerHeight;
                        const d = 25;
                        window.camera = new THREE.OrthographicCamera(-d * aspect, d * aspect, d, -d, 1, 1000);
                        camera.position.set(35, 35, 35);
                        camera.lookAt(0, 5, 0);

                        // Create renderer
                        window.renderer = new THREE.WebGLRenderer({ 
                            antialias: true,
                            alpha: true,
                            powerPreference: "high-performance"
                        });
                        renderer.setSize(window.innerWidth, window.innerHeight);
                        renderer.shadowMap.enabled = true;
                        renderer.shadowMap.type = THREE.PCFSoftShadowMap;
                        renderer.toneMapping = THREE.ACESFilmicToneMapping;
                        renderer.toneMappingExposure = 1.2;
                        renderer.outputEncoding = THREE.sRGBEncoding;
                        
                        // Clear container and add renderer
                        const container = document.getElementById('container');
                        container.innerHTML = '';
                        container.appendChild(renderer.domElement);

                        // Add lights
                        const ambientLight = new THREE.AmbientLight(0xffffff, 0.5);
                        scene.add(ambientLight);

                        const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
                        directionalLight.position.set(50, 50, 50);
                        directionalLight.castShadow = true;
                        scene.add(directionalLight);

                        // Add orbit controls for model interaction
                        window.controls = new THREE.OrbitControls(camera, renderer.domElement);
                        controls.enableDamping = true;
                        controls.dampingFactor = 0.05;
                        controls.screenSpacePanning = true;
                        
                        // Load USDZ model
                        const loader = new THREE.USDZLoader();
                        loader.load('3d_models/heart_model.usdz', (model) => {
                            console.log('Model loaded successfully');
                            
                            // Center the model
                            const box = new THREE.Box3().setFromObject(model);
                            const center = box.getCenter(new THREE.Vector3());
                            model.position.sub(center);
                            
                            // Scale the model to fit the view
                            const size = box.getSize(new THREE.Vector3());
                            const maxDim = Math.max(size.x, size.y, size.z);
                            const scale = 10 / maxDim;
                            model.scale.multiplyScalar(scale);
                            
                            scene.add(model);
                            
                            // Update camera position based on model size
                            camera.position.copy(new THREE.Vector3(1, 0.5, 1).multiplyScalar(maxDim * scale));
                            camera.lookAt(0, 0, 0);
                            
                            window.model = model;
                        }, 
                        // Progress callback
                        (xhr) => {
                            console.log((xhr.loaded / xhr.total * 100) + '% loaded');
                        },
                        // Error callback
                        (error) => {
                            console.error('Error loading model:', error);
                        });

                        // Animation function
                        function animate() {
                            requestAnimationFrame(animate);
                            controls.update();
                            renderer.render(scene, camera);
                        }

                        // Start animation
                        animate();

                        // Handle window resize
                        window.addEventListener('resize', () => {
                            const width = window.innerWidth;
                            const height = window.innerHeight;
                            camera.aspect = width / height;
                            camera.updateProjectionMatrix();
                            renderer.setSize(width, height);
                        });

                        // Recheck scene status after initialization
                        const postInitStatus = checkSceneStatus();
                        window.webkit.messageHandlers.iosNative.postMessage({
                            type: 'post-init-status',
                            status: postInitStatus
                        });
                    } catch (e) {
                        console.error('Error during Three.js initialization:', e);
                    }
                }
                
                // Add performance monitoring
                if (typeof performance !== 'undefined') {
                    let lastTime = performance.now();
                    let frames = 0;
                    
                    function checkPerformance() {
                        frames++;
                        const currentTime = performance.now();
                        if (currentTime >= lastTime + 1000) {
                            const fps = Math.round(frames * 1000 / (currentTime - lastTime));
                            window.webkit.messageHandlers.iosNative.postMessage({
                                type: 'performance',
                                fps: fps
                            });
                            frames = 0;
                            lastTime = currentTime;
                        }
                        requestAnimationFrame(checkPerformance);
                    }
                    
                    requestAnimationFrame(checkPerformance);
                }
                
                // Monitor WebGL context
                if (typeof renderer !== 'undefined' && renderer.getContext) {
                    const context = renderer.getContext();
                    const extensions = context.getSupportedExtensions();
                    window.webkit.messageHandlers.iosNative.postMessage({
                        type: 'webgl',
                        extensions: extensions,
                        version: context.getParameter(context.VERSION),
                        vendor: context.getParameter(context.VENDOR),
                        renderer: context.getParameter(context.RENDERER)
                    });
                }
            """
            webView.evaluateJavaScript(debug) { result, error in
                if let error = error {
                    print("Debug injection failed: \(error.localizedDescription)")
                }
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("WebView failed to load: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("WebView failed to load: \(error.localizedDescription)")
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "iosNative" {
                guard let dict = message.body as? [String: Any] else {
                    print("Invalid message format received")
                    return
                }
                
                let type = dict["type"] as? String ?? "unknown"
                
                switch type {
                case "webgl-status":
                    if let status = dict["status"] as? [String: Any] {
                        print("WebGL Status:", status)
                    }
                case "scene-status":
                    if let status = dict["status"] as? [String: Any] {
                        print("Scene Status:", status)
                    }
                case "dom-status":
                    if let status = dict["status"] as? [String: Any] {
                        print("DOM Status:", status)
                    }
                case "container-resize":
                    if let size = dict["size"] as? [String: Any] {
                        print("Container Resized:", size)
                    }
                case "post-init-status":
                    if let status = dict["status"] as? [String: Any] {
                        print("Post-Init Status:", status)
                    }
                case "error":
                    if let message = dict["message"] as? String {
                        print("Error:", message)
                    }
                case "performance":
                    if let fps = dict["fps"] as? Int {
                        print("FPS:", fps)
                    }
                default:
                    print("Received message from JavaScript:", dict)
                }
            }
        }
    }
}
