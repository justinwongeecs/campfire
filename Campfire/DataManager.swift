//
//  DataManager.swift
//  Campfire
//
//  Created by Justin Wong on 4/19/25.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let serverEndpoint = "https://7858-168-150-55-103.ngrok-free.app"
    
    private func createURLRequest(with url: URL, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = httpMethod
        return request
    }
    
    private func createURLRequestWithBearerToken(with url: URL, httpMethod: String, token: String) -> URLRequest {
        var request = createURLRequest(with: url, httpMethod: httpMethod)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func createLoginUser(withPhoneNumber phoneNumber: String) async -> Int? {
        guard let url = URL(string: "\(serverEndpoint)/sessions/create") else {
            return nil
        }

        var request = createURLRequest(with: url, httpMethod: "POST")
        let strippedPhoneNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).digits
        
        let json: [String: Any] = [
            "phone_number": "+1\(strippedPhoneNumber)"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Int]

            return responseJSON["user_id"]
        } catch {
            print("createLoginError: \(error)")
            return nil
        }
    }
    
    func verifyShortCode(for shortCode: String, withUserID userID: Int) async -> (user: CFUser, token: String)? {
        guard let url = URL(string: "\(serverEndpoint)/sessions/authenticate") else {
            return nil
        }
        
        var request = createURLRequest(with: url, httpMethod: "POST")
        let strippedShortCode = shortCode.trimmingCharacters(in: .whitespacesAndNewlines).digits
        
        let json: [String: Any] = [
            "user_id": String(userID),
            "short": strippedShortCode
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            let (data, _) = try await URLSession.shared.data(for: request)
            let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            print("ResponseJSON: \(responseJSON)")
            
            guard let userDict = responseJSON["user"] as? [String: Any],
                  let token = responseJSON["token"] as? String else {
                print("getting values failed")
                return nil
            }

            let userData = try JSONSerialization.data(withJSONObject: userDict)
            let user = try JSONDecoder().decode(CFUser.self, from: userData)
            print("User: \(user)")
            print("Token: \(token)")
            return (user, token)
        } catch {
            print("verify short code failed: \(error)")
            return nil
        }
    }
    
    func editUserFields(userID: Int, token: String, withData json: [String: Any]) async -> CFUser? {
        guard let url = URL(string: "\(serverEndpoint)/users/\(userID)/") else {
            return nil
        }

        var request = createURLRequestWithBearerToken(with: url, httpMethod: "PATCH", token: token)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            let (data, _) = try await URLSession.shared.data(for: request)
            let editedUser = try JSONDecoder().decode(CFUser.self, from: data)
            return editedUser
        } catch {
            print("editUser error: \(error)")
            return nil
        }
    }
    
    func fetchUser(token: String) async -> CFUser? {
        guard let url = URL(string: "\(serverEndpoint)/users/current/") else {
            return nil
        }
        
        let request = createURLRequestWithBearerToken(with: url, httpMethod: "GET", token: token)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let user = try JSONDecoder().decode(CFUser.self, from: data)
            return user
        } catch {
            print("fetchUser error: \(error)")
            return nil
        }
    }
    
    
    // MARK: - Contacts
    
    func uploadUserContacts(token: String) async {
        guard let url = URL(string: "\(serverEndpoint)/contacts/import") else {
            return
        }

        var request = createURLRequestWithBearerToken(with: url, httpMethod: "POST", token: token)

        ContactsManager.shared.fetchAllContacts()
        
        let formattedPhoneNumbers = ContactsManager.shared.userContacts.phoneNumbers().map { "+1\($0.digits)"}
        let json: [String: Any] = [
            "phone_numbers": formattedPhoneNumbers
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            
            let (_, _) = try await URLSession.shared.data(for: request)
        } catch {
            print("UploadUserContacts: \(error)")
            return
        }
    }
    
    
    // MARK: - Chatups
    
    func fetchChatupMessages(token: String) async -> [CFCatchUpMessage]? {
        guard let url = URL(string: "\(serverEndpoint)/messages") else {
            return nil
        }
        
        let request = createURLRequestWithBearerToken(with: url, httpMethod: "GET", token: token)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let messages = try JSONDecoder().decode([CFCatchUpMessage].self, from: data)
            return messages
        } catch {
            print("UploadUserContacts: \(error)")
            return nil
        }
    }
    
    func sendChatupMessage(for message: String, token: String) async -> [CFCatchUpMessage]? {
        guard let url = URL(string: "\(serverEndpoint)/messages") else {
            return nil
        }
        
        var request = createURLRequestWithBearerToken(with: url, httpMethod: "POST", token: token)
        
        let json: [String: Any] = [
            "content": message
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let messages = try JSONDecoder().decode([CFCatchUpMessage].self, from: data)
            return messages
        } catch {
            print("UploadUserContacts: \(error)")
            return nil
        }
    }
}
