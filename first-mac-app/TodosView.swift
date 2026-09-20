//
//  TodosView.swift
//  first-mac-app
//
//  Created by mostafa on 19.09.26.
//

import SwiftUI


struct Todo: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int?
    let title: String
    let completed: Bool
}

struct TodosView: View {
    
    
    @State private var todos: [Todo] = []
    
    @StateObject private var viewModel = TodosViewModel()
    
    @Binding var selectedTodo: Todo? // Receives binding from HomeView
    
   
    
    
    var body: some View {
        NavigationStack{
            
            List(viewModel.todos, selection: $selectedTodo){ todo in
                HStack {
                    Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(todo.completed ? .green : .gray)
                    Text(todo.title)
                        .foregroundStyle(.white)
                }
                .tag(todo)
                
            }
            .navigationTitle("Local Todos")
            .task {
                viewModel.loadLocalTodos()
                 //loadLocalTodos()
                 //await fetchTodos()
            }
        }
    }
    
    // 3. Local JSON loading function
       /* func loadLocalTodos() {
            guard let url = Bundle.main.url(forResource: "todos", withExtension: "json") else {
                print("todos.json file not found in bundle.")
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                todos = try JSONDecoder().decode([Todo].self, from: data)
            } catch {
                print("Failed to decode local JSON: \(error.localizedDescription)")
            }
        }*/
    
    
   
    
    
    
}
