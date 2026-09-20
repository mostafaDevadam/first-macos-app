//
//  UsersViewModel.swift
//  first-mac-app
//
//  Created by mostafa on 19.09.26.
//

import Foundation



struct User: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let address: Address
    let company: Company
}



struct Address: Codable, Hashable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Geo: Codable, Hashable {
    let lat: String
    let lng: String
}

struct Company: Codable, Hashable {
    let name: String
    let catchPhrase: String
    let bs: String
}

class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    
    func loadLocalUsers() {
        guard let url = Bundle.main.url(forResource: "users", withExtension: "json") else {
            print("users.json file not found in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            users = try JSONDecoder().decode([User].self, from: data)
        } catch {
            print("Failed to decode local JSON: \(error.localizedDescription)")
        }
    }
    
  
    
    
}
