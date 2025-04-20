//
//  OnboardingView.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct OnboardingCauroselView: View {
    var questions: [String]
    
    @Binding var selection: Int
    
    var body: some View {
        TabView(selection: $selection) {
            NameEntryView()
            ForEach(Array(questions.enumerated()), id: \.offset) { idx, question in
                OnboardingView(question: question, selection: $selection)
                    .tag(idx)
            }
        }
        .ignoresSafeArea()
    }
}

struct NameEntryView: View {
    @Environment(CampfireViewModel.self) private var viewModel
    @State private var nameText = ""
    
    var body: some View {
        ZStack {
            FireMeshGradientView()
            
            HeaderTitleTextFieldView(title: "Name:", text: $nameText)
            
            HStack {
                Spacer()
                CFOnboardingNextButton {
                    viewModel.setUsername(withName: nameText)
                }
            }
            .padding()
        }
    }
}


// MARK: - OnboardingView

struct OnboardingView: View {
    @Environment(CampfireViewModel.self) private var viewModel
    
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
        CFOnboardingNextButton {
            Task {
                await viewModel.addUserFact(userFactNum: selection, forQuestion: question, withAnswer: answerText)
                selection += 1
            }
        }
    }
}

#Preview("OnboardingCauroselView"){
    @Previewable @State var selection: Int = 0
    OnboardingCauroselView(questions: ["How are you doing?"], selection: $selection)
}

#Preview {
    @Previewable @State var selection: Int = 0
    OnboardingView(question: "What is your favorite event that happened in the past year?", selection: $selection)
}
