//
//  NotesView.swift
//  first-mac-app
//
//  Created by mostafa on 21.09.26.
//

import SwiftUI


struct NotesView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var inputTitle = ""
    @State private var inputBody = ""
    
    @Binding var selectedNote: Note? // 👈 Add binding

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Local Notes")
                .font(.headline)
            
            // Input Fields
            TextField("Note Title", text: $inputTitle)
                .textFieldStyle(.roundedBorder)
            
            TextField("Note Body", text: $inputBody)
                .textFieldStyle(.roundedBorder)
            
            Button("Save Note") {
                if !inputTitle.isEmpty {
                    viewModel.addNote(title: inputTitle, body: inputBody)
                    inputTitle = ""
                    inputBody = ""
                }
            }
            .buttonStyle(.borderedProminent)
            
            Divider()
            
            // Saved Notes List
            List(viewModel.notes, selection: $selectedNote){ note in
                //ForEach(viewModel.notes) { note in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(note.title).bold()
                        Text(note.body)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .tag(note)
                //}
                //.onDelete(perform: viewModel.delete)
            }
            .listStyle(.plain)
        }
        .padding()
    }
}
