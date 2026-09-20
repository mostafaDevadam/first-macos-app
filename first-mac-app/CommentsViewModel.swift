//
//  CommentsViewModel.swift
//  first-mac-app
//
//  Created by mostafa on 19.09.26.
//

import Foundation

struct Comment: Codable, Identifiable, Hashable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String 
}

class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    
    func loadLocalComments() {
        guard let url = Bundle.main.url(forResource: "comments", withExtension: "json") else {
            print("comments.json file not found in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            comments = try JSONDecoder().decode([Comment].self, from: data)
        } catch {
            print("Failed to decode local JSON: \(error.localizedDescription)")
        }
    }
    
    
    func commentsByPostId(for postId: Int) -> [Comment] {
        return comments.filter{ $0.postId == postId }
    }
    
  
    
    
}

