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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "text.quote")
                    .foregroundColor(.blue)
                Text("Caption")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                TextField("Share your immersive moment...", text: $viewModel.caption, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.body)
                    .lineLimit(3...6)
                
                HStack {
                    Spacer()
                    Text("\(viewModel.captionCharacterCount)/280")
                        .font(.caption)
                        .foregroundColor(viewModel.isCaptionValid ? .secondary : .red)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
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