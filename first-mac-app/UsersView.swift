//
//  UsersView.swift
//  first-mac-app
//
//  Created by mostafa on 19.09.26.
//

import SwiftUI

struct UsersView: View {
    
    @State private var users: [User] = []
    
    @StateObject private var viewModel = UsersViewModel()
    
    @Binding var selectedUser: User? // Receives binding from HomeView
    
    
    var body: some View {
        NavigationStack{
            
            List(viewModel.users, selection: $selectedUser){ user in
                HStack {
                    //Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                        //.foregroundColor(todo.completed ? .green : .gray)
                    Text(user.name)
                        .foregroundStyle(.white)
                }
                .tag(user)
                
            }
            .navigationTitle("Local Users")
            .task {
                viewModel.loadLocalUsers()
                 
            }
        }
    }
}


