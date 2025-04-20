//
//  CFProfileImageView.swift
//  Campfire
//
//  Created by Justin Wong on 4/20/25.
//

import SwiftUI

struct CFProfileImageView: View {
    var contactImage: UIImage
    var widthHeight: CGFloat = 100
    
    var body: some View {
        Image(uiImage: contactImage)
            .resizable()
            .frame(width: widthHeight, height: widthHeight)
            .clipShape(Circle())
            .shadow(color: .orange.opacity(0.6), radius: 10)
    }
}

struct CFPlaceholderImageView: View {
    var firstName: String
    var lastName: String
    var widthHeight: CGFloat = 100
    
    var body: some View {
        Circle()
            .fill(.orange)
            .frame(width: widthHeight, height: widthHeight)
            .overlay(
                HStack(spacing: 0) {
                    if !firstName.isEmpty {
                        Text(String(firstName.first ?? " "))
                    }
                    if !lastName.isEmpty {
                        Text(String(lastName.first ?? " "))
                    }
                }
                .foregroundStyle(.white)
                .font(.system(size: widthHeight / 2.3))
                .fontWeight(.semibold)
                .shadow(color: .white, radius: 20)
            )
    }
}

#Preview {
    CFPlaceholderImageView(firstName: "Justin", lastName: "Wong")
}
