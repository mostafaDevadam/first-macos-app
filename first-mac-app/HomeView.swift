//
//  HomeView.swift
//  first-mac-app
//
//  Created by mostafa on 18.09.26.
//

import SwiftUI


enum HomeTabs: String, CaseIterable {
    case profile = "Profile"
    case users = "Users"
    case posts = "Posts"
    case todos = "Todos"
    
    
    var icon: String {
        switch self {
            case .profile: return "person.crop.circle"
            case .users: return "person.2.fill"
            case .posts: return "doc.plaintext.fill"
            case .todos: return "checkmark.circle.fill"
        }
    }
}


struct HomeView: View {
    @AppStorage("isAuth") private var isAuth: Bool = false
    
    @State private var selectedTab: HomeTabs = .users
    
    // 1. Track the selected todo state here
    @State private var selectedTodo: Todo? = nil
    @State private var selectedUser: User? = nil
    @State private var selectedPost: Post? = nil
    
    @StateObject private var commentsViewModel = CommentsViewModel()
    
    var body: some View {
        
            
                
        HStack(spacing: 0) {
            // left
            VStack(alignment: .leading, spacing: 16){
                    Text("Menu")
                    .font(.subheadline)
                    .bold()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
                
                
                // items
                ForEach(HomeTabs.allCases, id: \.self) { tab in
                    
                    Button(action: {
                        selectedTab = tab
                    }) {
                        HStack {
                            Image(systemName: tab.icon)
                            Text(tab.rawValue)
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(selectedTab == tab ? Color.blue.opacity(0.15) : Color.clear)
                        .foregroundStyle(selectedTab == tab ? .blue : .primary)
                        .cornerRadius(8)
                    }
                   }
                Spacer()
                
                Button(action: { isAuth = false}) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                    }
                    .foregroundStyle(.red)
                    .padding()
                }
            }
            .frame(width: 180)
            .padding()
            .background(.secondary)
            .cornerRadius(8)
            
            Divider()
            
            // center
                    VStack{
                        switch selectedTab {
                            case .profile:
                                  //Text("profile...")
                                  ProfileView()
                            case .users:
                                  //Text("users...")
                            UsersView(selectedUser: $selectedUser)
                            
                            case .posts:
                                  PostsView(selectedPost: $selectedPost)
                            
                            case .todos:
                                  //Text("todos...")
                                  // 2. Pass the binding down to TodosView
                                  TodosView(selectedTodo: $selectedTodo)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
            
            // right
                    VStack(alignment: .leading, spacing: 12){
                        Text("Right")
                            .font(.headline)
                            .padding(.top)
                        Spacer()
                        // 3. Conditionally display selected todo or fallback text
                        if let todo = selectedTodo {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                                    .font(.largeTitle)
                                    .foregroundColor(todo.completed ? .green : .gray)
                                
                                Text("ID: \(todo.id)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                
                                Text(todo.title)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                               
                            }
                            .padding(.top, 4)
                        } else if let user = selectedUser {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                
                                Text("ID: \(user.id)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                
                                Text(user.name)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                Text(user.username)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                Text(user.phone)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                Text(user.website)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                // Grouping address details inside a nested VStack keeps the main stack under the 10-item limit
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Address")
                                            .font(.subheadline)
                                            .bold()
                                            .multilineTextAlignment(.leading)
                                        
                                        Text(user.address.street)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text(user.address.city)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.top, 4)
                                
                                // Company Section
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Company")
                                            .font(.subheadline)
                                            .bold()
                                        
                                        Text(user.company.name)
                                            .font(.subheadline)
                                            .multilineTextAlignment(.leading)
                                        
                                        Text(user.company.catchPhrase)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding(.top, 2)
                                
                                /*Text("Address")
                                    .font(.subheadline)
                                    .bold()
                                
                                Text(user.address.street)
                                    .font(.footnote)
                                    //.multilineTextAlignment(.leading)
                                
                                Text(user.address.city)
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                
                                Text("Company")
                                    .font(.subheadline)
                                    .bold()
                                
                                Text(user.company.name)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                Text(user.company.catchPhrase)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)*/
                               
                                
                               
                            }
                            .padding(.top, 4)
                            
                        }
                        else if let post = selectedPost {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                
                                
                                Text("ID: \(post.id)")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                
                                Text(post.title)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                
                                Text(post.body)
                                    .font(.caption)
                                    .multilineTextAlignment(.leading)
                                
                                Divider()
                                     .padding(.vertical, 4)
                                        
                                Text("Comments")
                                    .font(.caption)
                                    .bold()
                                    .foregroundStyle(.secondary)
                                
                                // comments
                                // comments list with proper frame constraints
                                List(commentsViewModel.commentsByPostId(for: post.id)) { comment in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(comment.name)
                                            .font(.headline)
                                        Text(comment.email)
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                        Text(comment.body)
                                            .font(.subheadline)
                                    }
                                    .padding(.vertical, 4)
                                }
                                .listStyle(.plain)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        
                              
                                
                               
                            }
                            .padding(.top, 4)
                            .task{
                                commentsViewModel.loadLocalComments()
                            }
                        }
                        
                        
                        
                        
                        else {
                            Text("No new alerts")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(.top, 4)
                        }
                        
                        Spacer()
                        // post
                        
                        
                        // user
                        
                    }
                    .frame(width: 180)
                    .padding()
                }
            .padding()
            .navigationTitle("Home")
        
    }
}

