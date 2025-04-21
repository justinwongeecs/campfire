//
//  HeaderTitleTextFieldView.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//


import SwiftUI

struct HeaderTitleTextFieldView: View {
    var title: String
    var placeholder: String = ""
    @Binding var text: String
    
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(CFFont.bold(18))
            TextField(placeholder, text: $text)
                .font(CFFont.italic(16))
                .padding(10)
                .background(.regularMaterial)
                .clipShape( RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                   RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.gray)
                )
        }
    }
}
