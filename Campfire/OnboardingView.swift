//
//  OnboardingView.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct OnboardingCauroselView: View {
    @State private var selection: Int = 0
    var body: some View {
        TabView(selection: $selection) {
            OnboardingView(question: "What is your favorite event that happened in the past year?", selection: $selection)
            OnboardingView(question: "How are you feeling today?", selection: $selection)
        }
        .tabViewStyle(.page)
        .ignoresSafeArea()
    }
}



// MARK: - OnboardingView

struct OnboardingView: View {
    var question: String
    @Binding var selection: Int
    
    @State private var answerText = ""
    
    var body: some View {
        ZStack {
            Color.orangeBackground
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text(question)
                    .font(CFFont.regular(20))
                    .fontWeight(.semibold)
                textEditorView
                Spacer()
                HStack {
                    Spacer()
                    nextButton
                }
                .padding()
            }
        }
    }
    
    private var textEditorView: some View {
        TextEditor(text: $answerText)
            .hideBackground()
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
            .font(CFFont.regular(17))
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        maxCountView
                    }
                }
                .padding(30)
            )
    }
    
    private var maxCountView: some View {
        Text("Characters: \(answerText.count)/240")
            .foregroundStyle(.gray)
            .font(CFFont.regular(15))
    }
    
    private var nextButton: some View {
        Button(action: {
            
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

#Preview("OnboardingCauroselView"){
    OnboardingCauroselView()
}

#Preview {
    @Previewable @State var selection: Int = 0
    OnboardingView(question: "What is your favorite event that happened in the past year?", selection: $selection)
}
