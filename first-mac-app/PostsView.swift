//
//  PostsView.swift
//  first-mac-app
//
//  Created by mostafa on 19.09.26.
//

import SwiftUI

struct PostsView: View {
    
    
    @State private var posts: [Post] = []
    
    @StateObject private var viewModel = PostsViewModel()
    
    @Binding var selectedPost: Post? // Receives binding from HomeView
    
    
    var body: some View {
        NavigationStack{
            
            List(viewModel.posts, selection: $selectedPost){ post in
                HStack {
                    Text(post.title)
                        .foregroundStyle(.white)
                }
                .tag(post)
                
            }
            .navigationTitle("Local Posts")
            .task {
                viewModel.loadLocalPosts()
                 
            }
        }
    }
    
    
}

