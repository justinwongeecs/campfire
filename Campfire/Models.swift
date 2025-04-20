//
//  Models.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import UIKit

struct CFUserKeyFact: Codable {
    var id: Int
    var createdAt: String
    var updatedAt: String
    var userID: Int
    var question: String
    var answer: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userID = "user_id"
        case question
        case answer
   }
}

struct CFUser: Codable {
    var id: Int
    var name: String?
    var phoneNumber: String
    var createdAt: String
    var updatedAt: String
    var onboarded: Bool
    var keyFacts: [CFUserKeyFact]
    var catchUp: CFCatchUp?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case onboarded
        case keyFacts = "facts"
        case catchUp = "catchup"
   }
}

struct CFCatchUpMessage: Codable {
    var id: Int
    var text: String
    var userID: Int
    var catchupID: Int
    var createdAt: String
    var updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text = "content"
        case userID = "user_id"
        case catchupID = "catchup_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CFCatchUpUser: Codable {
    var id: Int
    var name: String?
    var phoneNumber: String
    var createdAt: String
    var updatedAt: String
    var onboarded: Bool
    var keyFacts: [CFUserKeyFact]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phoneNumber = "phone_number"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case onboarded
        case keyFacts = "facts"
   }
}

struct CFCatchUp: Codable {
    var id: Int
    var contactID: Int
    var prompt: String
    var date: String
    var createdAt: String
    var updatedAt: String
    var otherUser: CFCatchUpUser
    
    enum CodingKeys: String, CodingKey {
        case id
        case contactID = "contact_id"
        case prompt
        case date
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case otherUser = "with"
    }
}

enum CFMessageDirection {
    case left
    case right
}

enum CFError: String, Error {
    case notAuthorizedContacts = "Request to access contacts was not authorized. Core functionality of Campfire will not be available."
}
