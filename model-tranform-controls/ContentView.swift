//
//  ContentView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
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
            
//                SimpleUSDZViewer()
//                .tabItem {
//                    Image(systemName: "cube")
//                    Text("Simple")
 //               }
  //              .tag(2)
            
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
    }
}

#Preview {
    ContentView()
}
