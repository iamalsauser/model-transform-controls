//
//  CaptionInputView.swift
//  Flam Post Builder
//
//  Created by Parth Sinh on 03/08/25.
//

import SwiftUI

struct CaptionInputView: View {
    @ObservedObject var viewModel: PostBuilderViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "text.quote")
                    .foregroundColor(.purple)
                Text("Post Caption")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                TextField("Share your immersive moment...", text: $viewModel.caption, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.black.opacity(0.5))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .lineLimit(3...6)
                
                HStack {
                    Spacer()
                    Text("\(viewModel.captionCharacterCount)/280")
                        .font(.caption)
                        .foregroundColor(viewModel.isCaptionValid ? .purple.opacity(0.7) : .red.opacity(0.7))
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.4))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
}

// MARK: - Preview
struct CaptionInputView_Previews: PreviewProvider {
    static var previews: some View {
        CaptionInputView(viewModel: PostBuilderViewModel())
            .background(Color.black)
            .previewLayout(.sizeThatFits)
    }
} 