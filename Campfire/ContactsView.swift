//
//  ContactsView.swift
//  Campfire
//
//  Created by Justin Wong on 4/20/25.
//

import Contacts
import SwiftUI

struct ContactsView: View {
    @Environment(CampfireViewModel.self) private var viewModel

    var body: some View {
        ScrollView(.vertical) {
            VStack {
                headerView
                ForEach(ContactsManager.shared.userContacts, id: \.identifier) { contact in
                    CFContactView(contact: contact)
                }
                .padding()
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 10) {
            Text("Contacts")
                .font(CFFont.regular(30))
            userProfileImageView
            streaksView
            Spacer()
        }
    }
    
    @ViewBuilder
    private var userProfileImageView: some View {
        if let currentUser = viewModel.currentUser,
           let currentUserImage = viewModel.fetchUserContactImage(withPhoneNumber: currentUser.phoneNumber) {
            CFProfileImageView(contactImage: currentUserImage)
        }
    }
    
    private var streaksView : some View {
        HStack {
            Text("Streaks 🔥: \(viewModel.streaksNum)")
                .font(CFFont.regular(18))
        }
    }
}


// MARK: - CFContactView

struct CFContactView: View {
    @Environment(CampfireViewModel.self) private var viewModel

    var contact: CNContact
    
    private struct Constants {
        static let widthHeight: CGFloat = 50
    }
    
    var body: some View {
        HStack(spacing: 10) {
            if let profileImageData = contact.imageData,
               let profileImage = UIImage(data: profileImageData) {
                CFProfileImageView(contactImage: profileImage, widthHeight: Constants.widthHeight)
            } else {
                CFPlaceholderImageView(firstName: contact.givenName, lastName: contact.familyName, widthHeight:  Constants.widthHeight)
            }
               
            VStack(alignment: .leading, spacing: 5) {
                Text(contact.fullName())
                    .font(CFFont.bold(16))
                Text(contact.phoneNumbers.first?.value.stringValue ?? "")
                    .font(CFFont.regular(13))
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContactsView()
        .environment(CampfireViewModel())
}
