//
//  ContentView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showWebView = false
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                PostBuilderView()
                    .tabItem {
                        Image(systemName: "cube.box")
                        Text("Post Builder")
                    }
                    .tag(0)
                
                USDZModelViewer()
                    .tabItem {
                        Image(systemName: "cube")
                        Text("USDZ Viewer")
                    }
                    .tag(1)
                
                VStack {
                    Button("Show 3D Room") {
                        showWebView = true
                    }
                    .padding()
                }
                .tabItem {
                    Image(systemName: "house.3d")
                    Text("3D Room")
                }
                .tag(2)
                
                RealityKitUSDZViewer()
                    .tabItem {
                        Image(systemName: "arkit")
                        Text("RealityKit")
                    }
                    .tag(3)
                
                USDZTestView()
                    .tabItem {
                        Image(systemName: "ladybug")
                        Text("Debug")
                    }
                    .tag(4)
            }
            .accentColor(.blue)
            
            if showWebView {
                WebView(htmlFile: "room")
                    .edgesIgnoringSafeArea(.all)
                    .background(Color(red: 0.4, green: 0.4, blue: 0.8)) // Debug background
                    .overlay(
                        Button(action: {
                            showWebView = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                        }
                            .padding(), alignment: .topTrailing
                    )
            }
        }
    }
    
}

