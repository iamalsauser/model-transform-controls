//
//  ModelSelectorView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

struct ModelSelectorView: View {
    @ObservedObject var viewModel: PostBuilderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                Text("3D Model")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 8) {
                ForEach(ModelType.allCases, id: \.self) { modelType in
                    ModelOptionCard(
                        modelType: modelType,
                        isSelected: viewModel.selectedModel == modelType,
                        action: {
                            viewModel.selectedModel = modelType
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

struct ModelOptionCard: View {
    let modelType: ModelType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: modelType.iconName)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .blue)
                    .frame(width: 24, height: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(modelType.displayName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Text(modelType.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue : Color(.systemGray5))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct ModelSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        ModelSelectorView(viewModel: PostBuilderViewModel())
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
} 