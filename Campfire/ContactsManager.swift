//
//  ContactsManager.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import Contacts
import UIKit

class ContactsManager {
    static let shared = ContactsManager()
    
    var error: CFError? = nil
    
    private let contactsStore = CNContactStore()
    private(set) var userContacts: [CNContact] = []
    
    init() {
        checkContactsAuthorizationStatus()
    }
    
    private func checkContactsAuthorizationStatus() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        switch status {
        case .notDetermined:
            // The person hasn't yet decided whether the app may access contact data.
            Task {
                _ = try await contactsStore.requestAccess(for: .contacts)
            }
        case .authorized:
            // The person authorizes access to all contact data.
            break
        default:
            error = CFError.notAuthorizedContacts
        }
    }
    
    func fetchAllContacts() {
        var contacts = [CNContact]()

        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor,
            CNContactEmailAddressesKey as CNKeyDescriptor,
            CNContactImageDataKey as CNKeyDescriptor // optional
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)

        do {
            try contactsStore.enumerateContacts(with: request) { contact, stop in
                contacts.append(contact)
            }
        } catch {
            print("Failed to fetch contacts: \(error)")
        }

        self.userContacts = contacts.sorted { $0.fullName().lowercased() < $1.fullName().lowercased() }
    }
    
    func getContactProfileImage(phoneNumber: String) -> UIImage? {
        let phoneNumberWithoutInternationalCode = String(phoneNumber.digits.dropFirst())
        guard let imageData = userContacts.filter({ $0.phoneNumbers.first?.value.stringValue.digits == phoneNumberWithoutInternationalCode }).first?.imageData else {
            return nil
        }
        
        return UIImage(data: imageData)
    }
}
