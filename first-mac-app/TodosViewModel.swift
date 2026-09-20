//
//  TodosViewModel.swift
//  first-mac-app
//
//  Created by mostafa on 19.09.26.
//

import Foundation

class TodosViewModel: ObservableObject {
    @Published var todos: [Todo] = []
    
    func loadLocalTodos() {
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
    }
    
    /*func fetchTodos() async {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            todos = try JSONDecoder().decode([Todo].self, from: data)
        }catch {
            print("Failed to fetch: \(error.localizedDescription)")
        }
        
    }*/
    
    
}
