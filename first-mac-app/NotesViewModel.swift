//
//  NotesViewModel.swift
//  first-mac-app
//
//  Created by mostafa on 21.09.26.
//

import Foundation

struct Note: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var title: String
    var body: String
}

class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = [] {
        didSet {
            saveNotes() // Automatically saves whenever notes change
        }
    }
    
    private let storageKey = "local_notes_storage"
    
    init() {
        loadNotes()
    }
    
    // Load from local storage
    func loadNotes() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Note].self, from: data) {
            notes = decoded
        }
    }
    
    // Save to local storage
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    // Add a new note
    func addNote(title: String, body: String) {
        let note = Note(title: title, body: body)
        notes.append(note)
    }
    
    // Delete a note
    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
    }
}
