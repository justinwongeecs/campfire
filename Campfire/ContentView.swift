//
//  ContentView.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct ContentView: View {
    @State private var phoneNumberText = ""
    
    var body: some View {
        ZStack {
            FireMeshGradientView()
            
            VStack {
                Spacer()
                Text("Campfire")
                Image("campfire")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Spacer()
                HeaderTitleTextFieldView(title: "Phone Number:", text: $phoneNumberText)
                Spacer()
                CFActionButton(title: "Let's Huddle!", colors: (.yellow, .red))
                Spacer()
            }
            .padding()
            .font(CFFont.bold(40))
        }
    }
}


// MARK: - FireMeshGradientView

struct FireMeshGradientView: View {
    @State private var isAnimating = false
    
    var body: some View {
        MeshGradient(width: 3, height: 3, points: [
                   [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                   [0.0, 0.5], [isAnimating ? 0.1 : 0.8, 0.5], [1.0, isAnimating ? 0.5 : 1],
                   [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
               ], colors: [
                .orange.opacity(0.8), .yellow, .red,
                   isAnimating ? .orange : .red, .yellow, .orange,
                .yellow.opacity(0.3), .orange.opacity(0.5), .red.opacity(0.3)
               ])
               .edgesIgnoringSafeArea(.all)
               .onAppear() {
                   withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                       isAnimating.toggle()
                   }
               }
    }
}

#Preview {
    ContentView()
}
