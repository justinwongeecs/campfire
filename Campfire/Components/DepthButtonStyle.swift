//
//  DepthButtonStyle.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct DepthButtonStyle: ButtonStyle {
    var color: Color
    var cornerRadius: CGFloat = 16
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color.white)
            .background {
                ZStack {
                    self.getBGView()
                        .opacity(0.5)
                        .offset(y: configuration.isPressed ? 0 : 8)
                        .padding(.horizontal, 2)

                    self.getBGView()
                }
            }
            .rotation3DEffect(.degrees(20), axis: (x: 1.0, y: 0.0, z: 0.0))
            .offset(y: configuration.isPressed ? 8 : 0)
            .animation(.interactiveSpring(), value: configuration.isPressed)
    }
    
    private func getBGView() -> some View {
        LinearGradient(
            colors: [color.opacity(0.5), color],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}
