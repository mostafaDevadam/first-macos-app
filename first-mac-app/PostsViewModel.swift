//
//  PostsViewModel.swift
//  first-mac-app
//
//  Created by mostafa on 19.09.26.
//

import Foundation

struct Post: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}


class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    func loadLocalPosts() {
        guard let url = Bundle.main.url(forResource: "posts", withExtension: "json") else {
            print("posts.json file not found in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            posts = try JSONDecoder().decode([Post].self, from: data)
        } catch {
            print("Failed to decode local JSON: \(error.localizedDescription)")
        }
    }
    
  
    
    
}
