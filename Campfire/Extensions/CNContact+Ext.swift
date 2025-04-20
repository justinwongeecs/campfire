//
//  CNContact+Ext.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import Contacts

extension CNContact {
    func fullName() -> String {
        self.givenName + " " + self.familyName
    }
}

extension Array where Element == CNContact {
    func phoneNumbers() -> [String] {
        flatMap { contact in
            contact.phoneNumbers.map { $0.value.stringValue }
        }
    }
}
