//
//  CatchupView.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct CatchupContactsContainerView: View {
    @State private var tabSelection = 0
    
    var body: some View {
        ZStack  {
            Color.orangeBackground
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $tabSelection) {
                    CatchupView(catchup: CFCatchUp.sample)
                        .tag(0)
                }
                .tabViewStyle(.page)
                CFPickerView(titles: ["Catchup", "Contacts"], selection: $tabSelection)
            }
        }
    }
}


// MARK: - CatchupView

struct CatchupView: View {
    var catchup: CFCatchUp
    
    @State private var messageText = ""
    
    var body: some View {
        VStack {
            Text("My Catchup")
                .font(CFFont.regular(30))
    
            Text(catchup.prompt)
                .font(CFFont.italic(20))
                .multilineTextAlignment(.center)
                .foregroundStyle(.orange)
                .padding()
            ForEach(catchup.messages) { message in
                CatchupMessageView(catchupMessage: message)
            }
            Spacer()
            SendMessageView(text: $messageText)
                .padding()
        }
    }
}


// MARK: - CatchupMessageView

struct CatchupMessageView: View {
    var catchupMessage: CFCatchUpMessage
    var direction = CFMessageDirection.left
    
    private struct Constants {
        static let messageBackgroundColor = Color.orange
    }
    
    var body: some View {
        HStack {
            if direction == .right {
                Spacer()
            }
            
            Text(catchupMessage.message)
                .font(CFFont.regular(16))
                    .padding()
                    .background(Constants.messageBackgroundColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    .listRowSeparator(.hidden)
                    .overlay(alignment: direction == .left ? .bottomLeading: .bottomTrailing) {
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.title)
                            .rotationEffect(.degrees(direction == .left ? 45: -45))
                            .offset(x: direction == .left ? -10: 10, y: 10)
                            .foregroundColor(Constants.messageBackgroundColor)
                    }
            
            if direction == .left {
                Spacer()
            }
        }
        .padding()
    }
}


// MARK: - SendMessageView

struct SendMessageView: View {
    @Binding var text: String
    
    @State private var isPressingSendMessageButton = false
    
    private let cornerRadius: CGFloat = 20
    
    var body: some View {
        HStack {
            textFieldView
            sendMessageButton
        }
    }
    
    private var textFieldView: some View {
        TextField("Send a message!", text: $text)
            .font(CFFont.regular(15))
            .padding(10)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(.orange, lineWidth: 0.5)
            )
    }
    
    private var sendMessageButton: some View {
        Button(action: {
            withAnimation {
                isPressingSendMessageButton.toggle()
            } completion: {
                withAnimation(.easeInOut(duration: 0.4)) {
                    isPressingSendMessageButton.toggle()
                }
            }
        }) {
            Image(systemName: "arrow.up.circle.fill")
                .foregroundStyle(.orange)
                .font(.system(size: 35))
                .scaleEffect(isPressingSendMessageButton ? 1.3 : 1.0)
        }
    }
}

#Preview("CatchupContactsContainerView") {
    CatchupContactsContainerView()
}

#Preview {
    CatchupView(catchup: CFCatchUp.sample)
}
