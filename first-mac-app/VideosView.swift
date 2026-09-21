import SwiftUI
import AVKit

// Model with Codable, Identifiable, and Hashable
struct SavedVideo: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let bookmarkData: Data
}

struct VideosView: View {
    @State private var videoList: [SavedVideo] = []
    @State private var isImporterPresented = false
    @State private var selectedVideo: SavedVideo? = nil
    @State private var avPlayer: AVPlayer? = nil
    
    private let storageKey = "SavedVideosListKey"

    var body: some View {
        HStack(spacing: 0) {
            leftPane
            Divider()
            rightPane
        }
        // macOS 13 fileImporter signature uses Result<URL, Error> for single selection
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.movie],
            allowsMultipleSelection: false
        ) { result in
            handleFileSelection(result: result)
        }
        .onAppear {
            loadSavedVideos()
        }
        // macOS 13 compatible onChange signature
        .onChange(of: selectedVideo) { newVideo in
            setupPlayer(for: newVideo)
        }
    }
    
    // MARK: - 1. Left Pane Component
    private var leftPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Video Library")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                Button {
                    isImporterPresented = true
                } label: {
                    Label("Upload", systemImage: "plus")
                }
                .buttonStyle(.borderedProminent)
            }
            
            List(selection: $selectedVideo) {
                ForEach(videoList) { video in
                    HStack(spacing: 12) {
                        Image(systemName: selectedVideo == video ? "film.fill" : "film")
                            .foregroundStyle(selectedVideo == video ? .blue : .secondary)
                        
                        Text(video.name)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    .contentShape(Rectangle())
                    .tag(video)
                }
                .onDelete(perform: deleteVideo)
            }
            .listStyle(.plain)
            .background(.gray.opacity(0.05))
            .cornerRadius(8)
        }
        .padding(20)
        .frame(minWidth: 280, maxWidth: 350)
    }
    
    // MARK: - 2. Right Pane Component
    private var rightPane: some View {
        VStack(alignment: .leading) {
            if let video = selectedVideo {
                videoDetailsContainer(for: video)
            } else {
                emptyStateView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    // MARK: - 3. Video Details Container
    private func videoDetailsContainer(for video: SavedVideo) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Header
            HStack(spacing: 12) {
                Image(systemName: "play.rectangle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(video.name)
                        .font(.headline)
                        .lineLimit(1)
                    Text("ID: \(String(video.id.uuidString.prefix(8)))...")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Divider()
            
            // Metadata GroupBox
            GroupBox("File Metadata") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Filename:")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(video.name)
                            .lineLimit(1)
                    }
                    HStack {
                        Text("Storage Status:")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text("Secured Bookmark Active")
                            .foregroundStyle(.green)
                    }
                }
                .padding(.vertical, 4)
            }
            
            // Video Player Section
            videoPlayerSection
            
            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    // MARK: - 4. Video Player Sub-component
    private var videoPlayerSection: some View {
        VStack(spacing: 12) {
            Text("Video Player")
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let player = avPlayer {
                VideoPlayer(player: player)
                    .frame(height: 220)
                    .cornerRadius(8)
                    .shadow(radius: 2)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.black.opacity(0.1))
                    .frame(height: 220)
                    .overlay {
                        Text("Loading Player...")
                            .foregroundStyle(.secondary)
                    }
            }
        }
    }
    
    // MARK: - 5. Empty State Sub-component
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "film.stack")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text("No Video Selected")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Choose a video from your library on the left to view details and watch playback.")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 250)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Helper Methods (macOS 13 Compatible)
    private func handleFileSelection(result: Result<[URL], Error>) {
        do {
            // Grab the first URL from the array result
            guard let fileURL = try result.get().first else { return }
            
            guard fileURL.startAccessingSecurityScopedResource() else { return }
            defer { fileURL.stopAccessingSecurityScopedResource() }
            
            let bookmarkData = try fileURL.bookmarkData(
                options: .securityScopeAllowOnlyReadAccess,
                includingResourceValuesForKeys: nil,
                relativeTo: nil
            )
            
            let newVideo = SavedVideo(id: UUID(), name: fileURL.lastPathComponent, bookmarkData: bookmarkData)
            videoList.append(newVideo)
            saveVideosToStorage()
            selectedVideo = newVideo
            
        } catch {
            print("Failed to import video: \(error.localizedDescription)")
        }
    }
    
    private func setupPlayer(for video: SavedVideo?) {
        avPlayer?.pause()
        avPlayer = nil
        
        guard let video = video else { return }
        
        do {
            var isStale = false
            let fileURL = try URL(
                resolvingBookmarkData: video.bookmarkData,
                options: .withSecurityScope,
                relativeTo: nil,
                bookmarkDataIsStale: &isStale
            )
            
            guard fileURL.startAccessingSecurityScopedResource() else { return }
            defer { fileURL.stopAccessingSecurityScopedResource() }
            
            avPlayer = AVPlayer(url: fileURL)
            
        } catch {
            print("Failed to setup video player: \(error.localizedDescription)")
        }
    }
    
    private func deleteVideo(at offsets: IndexSet) {
        let itemsToDelete = offsets.map { videoList[$0] }
        if let selected = selectedVideo, itemsToDelete.contains(selected) {
            avPlayer?.pause()
            avPlayer = nil
            selectedVideo = nil
        }
        videoList.remove(atOffsets: offsets)
        saveVideosToStorage()
    }
    
    private func saveVideosToStorage() {
        if let encoded = try? JSONEncoder().encode(videoList) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadSavedVideos() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([SavedVideo].self, from: savedData) {
            videoList = decoded
        }
    }
}
