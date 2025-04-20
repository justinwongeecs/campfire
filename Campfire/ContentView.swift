//
//  ContentView.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = CampfireViewModel()
    @State private var onboardingCauroselSelection = 0
    @State private var phoneNumberText = ""
    @State private var shortCodeText = ""
    
    private let questions = [
        "What is your favorite event that happened in the past year?",
        "Where are you currently situated?",
        "What do you spend the most of your day doing?"
    ]
    
    var body: some View {
        if viewModel.currentUser == nil {
            loginView
        } else if !viewModel.currentUser!.onboarded && onboardingCauroselSelection <= questions.count {
            OnboardingCauroselView(questions: questions, selection: $onboardingCauroselSelection)
                .environment(viewModel)
        } else {
            CatchupContactsContainerView()
                .onAppear {
                    viewModel.fetchUserContacts()
                }
                .environment(viewModel)
        }
    }
    
    private var loginView: some View {
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
                CFActionButton(title: "Let's Huddle!", colors: (.yellow, .red)) {
                    viewModel.loginUser(withPhoneNumber: phoneNumberText)
                }
                Spacer()
            }
            .padding()
            .font(CFFont.bold(40))
        }
        .alert("Enter Code", isPresented: $viewModel.shouldShowShortCodeView) {
           TextField("Code", text: $shortCodeText)
            Button("OK", action: {
                viewModel.authenticateUser(withShortCode: shortCodeText)
            })
       } message: {
           Text("Code should have been sent via a text message.")
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
