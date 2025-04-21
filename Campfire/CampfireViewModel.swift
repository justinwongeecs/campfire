//
//  CampfireViewModel.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import Contacts
import Observation
import SwiftUI

@MainActor
@Observable
class CampfireViewModel {
    @ObservationIgnored
    private var userID: Int?
    
    var currentUser: CFUser?
    var shouldShowShortCodeView = false
    var isFetching = false
    
    var chatupMessages: [CFCatchUpMessage] = []
    var doBlurMessages: Bool {
        guard let currentUser else {
            return true
        }
        
        let messageCatchupIDs = chatupMessages.map { $0.userID }
        let messageCatchupIDSSet = Set(messageCatchupIDs)
        
        guard messageCatchupIDSSet.count == 1 else {
            return false
        }
    
        return Array(messageCatchupIDSSet).first! != currentUser.id
    }
    
    var streaksNum: Int {
        let sortedDates = chatupMessages
            .compactMap { $0.createdAt.toDateFromISOString() }
            .sorted(by: { $0 > $1 }) // Newest first

        return getNumOfStreaks(sortedDates: sortedDates)
    }
    
    private var authToken: String?
    
    func loginUser(withPhoneNumber phoneNumber: String) {
        Task {
            let userID = await DataManager.shared.createLoginUser(withPhoneNumber: phoneNumber)
            self.userID = userID

            if self.userID != nil {
                shouldShowShortCodeView = true
            }
        }
    }
    
    func authenticateUser(withShortCode shortCode: String) {
        guard let userID else {
            print("UserID is nil :(")
            return
        }
        
        Task {
            guard let userTokenData = await DataManager.shared.verifyShortCode(for: shortCode, withUserID: userID) else {
                print("UserTokenData is nil")
                return
            }
            
            currentUser = userTokenData.user
            authToken = userTokenData.token
        }
    }
    
    func setUsername(withName name: String) {
        guard let userID,
              let authToken else {
            print("UserID or authToken is nil :(")
            return
        }
        
        Task {
            let newUser = await DataManager.shared.editUserFields(userID: userID, token: authToken, withData: [
                "name": name
            ])
            currentUser = newUser
        }
    }
    
    func addUserFact(userFactNum: Int, forQuestion question: String, withAnswer answer: String) async {
        guard let userID,
              let authToken else {
            print("UserID or authToken is nil :(")
            return
        }
        
        let currDateISOString = Date().getISOString()
        let newFact = CFUserKeyFact(id: userFactNum, createdAt: currDateISOString, updatedAt: currDateISOString, userID: userID, question: question, answer: answer)
        
        do {
            let newFactData = try JSONEncoder().encode(newFact)
            guard let newFactJSONObj = try JSONSerialization.jsonObject(with: newFactData) as? [String: Any] else {
                print("Failed to convert encoded fact to JSON object")
                return
            }
            let newFactJSON: [String: Any] = [
                "facts": [newFactJSONObj]
            ]
            
            let newUser = await DataManager.shared.editUserFields(userID: userID, token: authToken, withData: newFactJSON)
            currentUser = newUser
        } catch {
            print("AddUserFact: \(error)")
        }
    }
    
    func getUser() {
        guard let authToken else {
            print("UserID or authToken is nil :(")
            return
        }
        
        Task {
            currentUser = await DataManager.shared.fetchUser(token: authToken)
        }
    }
    
    
    // MARK: - Contacts
    
    func fetchUserContacts() {
        guard let authToken else {
            print("AuthToken is nil :(")
            return
        }
        
        Task {
            await DataManager.shared.uploadUserContacts(token: authToken)
        }
    }
    
    func fetchUserContactImage(withPhoneNumber phoneNumber: String) -> UIImage? {
        ContactsManager.shared.getContactProfileImage(phoneNumber: phoneNumber)
    }
    
    func fetchChatupMessages() {
        guard let authToken else {
            print("AuthToken is nil :(")
            return
        }
        
        Task {
            isFetching = true
            chatupMessages = await DataManager.shared.fetchChatupMessages(token: authToken) ?? []
            isFetching = false
        }
    }
    
    func sendChatupMessage(for message: String) {
        guard let authToken else {
            print("AuthToken is nil :(")
            return
        }
        
        Task {
            isFetching = true
            chatupMessages = await DataManager.shared.sendChatupMessage(for: message, token: authToken) ?? []
            isFetching = false
        }
    }
    
    
    // MARK: - Helper Functions
    
    private func getNumOfStreaks(sortedDates: [Date]) -> Int {
        let calendar = Calendar.current
        let uniqueDays = Array(Set(sortedDates.map { calendar.startOfDay(for: $0) })).sorted(by: >)
        
        guard uniqueDays.count >= 1 else {
            return 0
        }

        var streak = 1
        for i in 1..<uniqueDays.count {
            let prev = uniqueDays[i - 1]
            let curr = uniqueDays[i]
            if let diff = calendar.dateComponents([.day], from: curr, to: prev).day, diff == 1 {
                streak += 1
            } else {
                break
            }
        }
        
        return streak
    }
}
