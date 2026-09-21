//
//  MusicsView.swift
//  first-mac-app
//
//  Created by mostafa on 21.09.26.
//

import SwiftUI
import AVFoundation // 👈 Required for audio playback


// 1. Model to store persistent music metadata & security bookmark data
struct SavedMusic: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let bookmarkData: Data // Required for macOS sandboxed file persistence
}

struct MusicsView: View {
    @State private var musicList: [SavedMusic] = []
    @State private var isImporterPresented = false
    
    // Playback state
    @State private var audioPlayer: AVAudioPlayer? = nil
    @State private var currentlyPlayingID: UUID? = nil
    
    private let storageKey = "SavedMusicsListKey"

    var body: some View {
        VStack(spacing: 20) {
            
            // Header & Upload Button
            HStack {
                Text("My Music Library")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button {
                    isImporterPresented = true
                } label: {
                    Label("Upload Music", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            
            Divider()
            
            // List of Saved Music
            List {
                ForEach(musicList) { music in
                    HStack(spacing: 12) {
                        // Play/Pause icon indicator
                        Image(systemName: currentlyPlayingID == music.id ? "speaker.wave.3.fill" : "music.note")
                            .foregroundStyle(currentlyPlayingID == music.id ? .green : .blue)
                            .font(.title3)
                        
                        Text(music.name)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // Play button per row
                        Button {
                            playMusic(music)
                        } label: {
                            Image(systemName: currentlyPlayingID == music.id ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title2)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        playMusic(music)
                    }
                }
                .onDelete(perform: deleteMusic)
            }
            .listStyle(.plain)
            .background(.gray.opacity(0.05))
            .cornerRadius(8)
            
        }
        .padding(20)
        .onAppear {
            loadSavedMusics()
        }
        // File Importer for Audio Files
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            handleFileSelection(result: result)
        }
    }
    
    // MARK: - File Handling & Persistence
    
    private func handleFileSelection(result: Result<[URL], Error>) {
        do {
            guard let fileURL = try result.get().first else { return }
            
            // Secure access to the selected file
            guard fileURL.startAccessingSecurityScopedResource() else { return }
            defer { fileURL.stopAccessingSecurityScopedResource() }
            
            // Create a security-scoped bookmark so the file remains accessible after app relaunch
            let bookmarkData = try fileURL.bookmarkData(
                options: .securityScopeAllowOnlyReadAccess,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            
            let newMusic = SavedMusic(
                id: UUID(),
                name: fileURL.lastPathComponent,
                bookmarkData: bookmarkData
            )
            
            musicList.append(newMusic)
            saveMusicsToStorage()
            
        } catch {
            print("Failed to import audio file: \(error.localizedDescription)")
        }
    }
    
    private func playMusic(_ music: SavedMusic) {
        do {
            var isStale = false
            // Resolve the secure bookmark back to an active file URL
            let fileURL = try URL(
                resolvingBookmarkData: music.bookmarkData,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            
            guard fileURL.startAccessingSecurityScopedResource() else { return }
            defer { fileURL.stopAccessingSecurityScopedResource() }
            
            // If already playing this track, pause it
            if currentlyPlayingID == music.id, let player = audioPlayer, player.isPlaying {
                player.pause()
                currentlyPlayingID = nil
                return
            }
            
            // Initialize and play new track
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            currentlyPlayingID = music.id
            
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    private func deleteMusic(at offsets: IndexSet) {
        musicList.remove(atOffsets: offsets)
        saveMusicsToStorage()
    }
    
    private func saveMusicsToStorage() {
        if let encoded = try? JSONEncoder().encode(musicList) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadSavedMusics() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([SavedMusic].self, from: savedData) {
            musicList = decoded
        }
    }
}
