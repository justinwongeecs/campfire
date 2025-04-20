//
//  Models.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import UIKit

struct CFUserKeyFacts {
    var question: String
    var answer: String
}

struct CFUser {
    var id: UUID
    var name: String
    var profileImage: UIImage
    var phoneNumber: String
    var keyFacts: [CFUserKeyFacts]
    var catchUps: [CFCatchUp]
}

struct CFCatchUpMessage: Identifiable {
    let id = UUID()
    var senderID: UUID
    var timestamp: Date
    var message: String
}

struct CFCatchUp {
    var id = UUID()
    static let sample = CFCatchUp(userIDs: [], prompt: "What was the most memorable event in the past couple weeks?", messages: [CFCatchUpMessage(senderID: UUID(), timestamp: Date(), message: "How are you doing?"), CFCatchUpMessage(senderID: UUID(), timestamp: Date(), message: "That's awesome! That's so good to see you! Hope you are doing well as well.")])
    var userIDs: [UUID]
    var prompt: String
    var messages: [CFCatchUpMessage]
}

enum CFMessageDirection {
    case left
    case right
}
