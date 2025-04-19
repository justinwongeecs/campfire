//
//  CFActionButton.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct CFActionButton: View {
    var title: String
    var colors: (start: Color, end: Color)
    var completion: (() -> Void)?
    
    var body: some View {
        Button(action: {
            completion?()
        }) {
            Text(title)
                .font(CFFont.bold(20))
                .padding()
                .foregroundStyle(.white)
                .background(RadialGradient(colors: [colors.start.opacity(0.3), colors.end], center: .center, startRadius: 5, endRadius: 60))
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(DepthButtonStyle(color: .red))
    }
}
