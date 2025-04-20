//
//  CatchupView.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import SwiftUI

struct CatchupContactsContainerView: View {
    @Environment(CampfireViewModel.self) private var viewModel
    
    @State private var showKeyFactsView = false
    @State private var tabSelection = 0
    
    var body: some View {
        ZStack {
            Color.orangeBackground
                .ignoresSafeArea()
            
            VStack {
                TabView(selection: $tabSelection) {
                    if viewModel.isFetching {
                        ProgressView()
                    } else if let currUser = viewModel.currentUser {
                        CatchupView(catchup: currUser.catchUp, showKeyFactsView: $showKeyFactsView)
                            .tag(0)
                        ContactsView()
                            .tag(1)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                CFPickerView(titles: ["Catchup", "Contacts"], selection: $tabSelection)
            }
            
            if showKeyFactsView {
                keyFactsView
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            viewModel.fetchChatupMessages()
            viewModel.currentUser?.catchUp?.otherUser.keyFacts = [
                CFUserKeyFact(id: 0, createdAt: "", updatedAt: "", userID: 0, question: "How are you doing?", answer: "I'm doing great. Thanks for asking!")
            ]
        }
    }
    
    @ViewBuilder
    private var keyFactsView: some View {
        if let otherUser = viewModel.currentUser?.catchUp?.otherUser, !otherUser.keyFacts.isEmpty {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        withAnimation {
                            showKeyFactsView.toggle()
                        }
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                ScrollView(.vertical) {
                    ForEach(otherUser.keyFacts, id: \.id) { keyFact in
                        VStack(spacing: 10) {
                            HStack {
                                Text(keyFact.question)
                                    .font(CFFont.bold(16))
                                Spacer()
                            }
                            HStack {
                                Spacer()
                                Text(keyFact.answer)
                                    .font(CFFont.regular(16))
                            }
                        }
                    }
                }
            }
            .padding(.top, 50)
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}


// MARK: - CatchupView

struct CatchupView: View {
    @Environment(CampfireViewModel.self) private var viewModel

    var catchup: CFCatchUp?
    
    @State private var messageText = ""
    @Binding var showKeyFactsView: Bool
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    Text("My Catchup")
                        .font(CFFont.regular(30))
                    
                    otherUserContactImage
                        .overlay(
                            Button(action: {
                                withAnimation {
                                    showKeyFactsView.toggle()
                                }
                            }) {
                                Image(systemName: "info.circle.fill")
                                    .font(.system(size: 25))
                                    .foregroundStyle(.orange)
                            }
                                .offset(x: 38, y: -38)
                        )
                    Text(catchup?.otherUser.name ?? "")
                        .font(CFFont.bold(18))
                    
                    if let catchup {
                        ZStack {
                            VStack {
                                Text(catchup.prompt)
                                    .font(CFFont.italic(20))
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.orange)
                                    .padding()
                            ForEach(viewModel.chatupMessages, id: \.id) { message in
                                    CatchupMessageView(catchupMessage: message)
                                }
                            }
                        }
                    } else {
                        CFEmptyView(message: "No Catchups Available For Today")
                    }
                }
                .padding(.bottom, 100)
            }
            
            VStack {
                Spacer()
                
                SendMessageView(text: $messageText)
                    .padding()
                    .background(.regularMaterial)
            }
        }
    }
    
    @ViewBuilder
    private var otherUserContactImage: some View {
        if let otherUser = catchup?.otherUser, let contactImage = viewModel.fetchUserContactImage(withPhoneNumber: otherUser.phoneNumber) {
            CFProfileImageView(contactImage: contactImage)
        }
    }
}


// MARK: - CatchupMessageView

struct CatchupMessageView: View {
    @Environment(CampfireViewModel.self) private var viewModel
    
    var catchupMessage: CFCatchUpMessage
    
    var body: some View {
        if let currentUserID = viewModel.currentUser?.id {
            let direction: CFMessageDirection = currentUserID == catchupMessage.userID ? .right : .left
            HStack {
                if direction == .right {
                    Spacer()
                }
                
                VStack(alignment: direction == .right ? .trailing : .leading) {
                    CatchupMessageBubbleView(catchupMessage: catchupMessage, direction: direction)
                }
               
                if direction == .left {
                    Spacer()
                }
            }
            .padding()
        }
    }
}


// MARK: - CatchupMessageBubbleView

struct CatchupMessageBubbleView: View {
    @Environment(CampfireViewModel.self) private var viewModel
    
    var catchupMessage: CFCatchUpMessage
    var direction: CFMessageDirection
    
    private struct Constants {
        static let messageBackgroundColor = Color.orange
    }
    
    var body: some View {
        Text(catchupMessage.text)
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
            .blur(radius: viewModel.doBlurMessages ? 10 : 0)
    }
}


// MARK: - SendMessageView

struct SendMessageView: View {
    @Environment(CampfireViewModel.self) private var viewModel
    
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
            
            viewModel.sendChatupMessage(for: text)
            
            text = ""
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
        .environment(CampfireViewModel())
}
