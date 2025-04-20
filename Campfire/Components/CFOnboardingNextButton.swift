//
//  CFOnboardingNextButton.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct CFOnboardingNextButton: View {
    var completion: (() -> Void)?
    
    var body: some View {
        Button(action: {
            completion?()
        }) {
            Circle()
                .fill(.regularMaterial)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "arrow.right")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundStyle(.orange)
                )
                .compositingGroup()
                .shadow(color: .orange, radius: 10)
        }
    }
}
