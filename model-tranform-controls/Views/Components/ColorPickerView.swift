//
//  ColorPickerView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

struct ColorPickerView: View {
    @ObservedObject var viewModel: PostBuilderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "paintpalette")
                    .foregroundColor(.blue)
                Text("Color")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 8) {
                ForEach(viewModel.colorPresets, id: \.self) { color in
                    ColorOptionButton(
                        color: color,
                        isSelected: viewModel.modelColor == color,
                        action: {
                            viewModel.setColor(color)
                        }
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ColorOptionButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 36, height: 36)
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
                )
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(viewModel: PostBuilderViewModel())
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
} 