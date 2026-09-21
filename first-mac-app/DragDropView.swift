//
//  DragDropView.swift
//  first-mac-app
//
//  Created by mostafa on 21.09.26.
//

import SwiftUI


struct DroppedItem: Identifiable, Hashable {
    let id = UUID()
    let icon: String
    let text: String
}


struct DragDropView: View {
    @State private var droppedText: String = "Drop text here..."
    @State private var droppedIcon: String = "questionmark.circle"
    
    
    var body: some View {
        Text("DnD-Screen")
        
        DragDropListView()
        
        Spacer()
        
        VStack(spacing: 20) {
                    
                    // 1. The Draggable Text View
                        HStack(spacing: 8) {
                            Image(systemName: "star.fill") // 👈 Drag handle icon
                                .foregroundStyle(.secondary)
                            
                            Text("Drag me: Hello SwiftUI!")
                        }
                        .padding()
                        .background(.blue.opacity(0.2))
                        .cornerRadius(8)
                        //.draggable("Hello SwiftUI!") // 👈 Makes this text draggable
                        .draggable("star.fill|Hello SwiftUI!") {
                                        HStack(spacing: 8) {
                                            Image(systemName: "star.fill")
                                                //.foregroundStyle(.secondary)
                                            Text("Hello SwiftUI!")
                                        }
                                        .padding()
                                        //.background(.blue.opacity(0.3))
                                        //.cornerRadius(8)
                                    }
                    
                    Divider()
                    
                    // 2. The Drop Target Area
                        HStack(spacing: 8) {
                            Image(systemName: droppedIcon)
                                .foregroundStyle(.blue)
                            
                            Text(droppedText)
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity, minHeight: 100)
                        .background(.gray.opacity(0.1))
                        .cornerRadius(8)
                        .dropDestination(for: String.self) { items, location in
                            /*if let firstItem = items.first {
                                droppedText = "Dropped: \(firstItem)"
                                return true
                            }*/
                            if let rawItem = items.first {
                                // Split our custom string back into icon name and text
                                let components = rawItem.components(separatedBy: "|")
                                if components.count == 2 {
                                    droppedIcon = components[0]
                                    droppedText = components[1]
                                    return true
                                }
                            }
                            return false
                        }
                }
                .padding()
        
    }
}




struct DragDropListView: View {
    // State holding an array of all dropped items
    @State private var droppedItems: [DroppedItem] = []
    
    // State for Deletion Alert
        @State private var itemToDelete: DroppedItem? = nil
        @State private var showingDeleteAlert = false
        
        // State for Toast Notification
        @State private var showToast = false
        @State private var toastMessage: String? = nil
    
    
    func removeItem(at offsets: IndexSet){
        droppedItems.remove(atOffsets: offsets)
    }
    
    // Helper function to handle toast display and auto-dismissal
        func triggerToast(_ message: String) {
            toastMessage = message
            withAnimation(.easeInOut) {
                showToast = true
            }
            
            // Hide after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut) {
                    showToast = false
                }
            }
        }

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 20) {
                
                // 1. Draggable Item
                HStack(spacing: 8) {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                    
                    Text("Drag me: Hello SwiftUI!")
                }
                .padding()
                .background(.blue.opacity(0.15))
                .cornerRadius(8)
                .draggable("star.fill|Hello SwiftUI!") {
                    // Drag preview
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text("Hello SwiftUI!")
                    }
                    .padding()
                    .background(.blue.opacity(0.3))
                    .cornerRadius(8)
                }
                
                Divider()
                
                // 2. Drop Target Area / List
                VStack(alignment: .leading) {
                    Text("Dropped Items List:")
                        .font(.headline)
                    
                    List {
                        ForEach(droppedItems) { item in
                            DroppedItemRow(item: item) {
                                itemToDelete = item
                                showingDeleteAlert = true
                            }
                            .listRowInsets(EdgeInsets()) // Removes default list margins for a flush look
                            .padding(.vertical, 2)
                            .contextMenu {
                                Button("Delete", role: .destructive) {
                                    itemToDelete = item
                                    showingDeleteAlert = true
                                }
                            }
                            /*HStack(spacing: 8) {
                                Image(systemName: item.icon)
                                    .foregroundStyle(.blue)
                                Text(item.text)
                                Spacer()
                                
                                // 1. Direct Delete Button on the row
                                Button(role: .destructive) {
                                    /*if let index = droppedItems.firstIndex(of: item) {
                                        droppedItems.remove(at: index)
                                    }*/
                                    itemToDelete = item
                                                                        showingDeleteAlert = true
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundStyle(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                            .contentShape(Rectangle())
                            // 2. Right-Click Context Menu Support
                            .contextMenu {
                                Button("Delete", role: .destructive) {
                                    /*if let index = droppedItems.firstIndex(of: item) {
                                        droppedItems.remove(at: index)
                                    }*/
                                    itemToDelete = item
                                    showingDeleteAlert = true
                                }
                            }*/
                        }
                        //.onDelete(perform: removeItem)
                    }
                    .frame(minHeight: 150)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .listStyle(.plain)
                }
                .dropDestination(for: String.self) { items, location in
                    if let rawItem = items.first {
                        let components = rawItem.components(separatedBy: "|")
                        if components.count == 2 {
                            let iconName = components[0]
                            let textContent = components[1]
                            
                            // Append the new dropped item to the array!
                            let newItem = DroppedItem(icon: iconName, text: textContent)
                            droppedItems.append(newItem)
                            return true
                        }
                    }
                    return false
                }
            }
            .padding()
            
            // 3. The Toast overlay goes here (the foreground layer)
                        if showToast, let message = toastMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text(message)
                                    .font(.subheadline)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .padding(.bottom, 20)
                            // Adds a smooth slide-up and fade animation
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
            
        }
        
        // Confirmation Alert Modifier
                .alert("Delete Item", isPresented: $showingDeleteAlert, presenting: itemToDelete) { item in
                    Button("Delete", role: .destructive) {
                        if let index = droppedItems.firstIndex(of: item) {
                            let deletedTitle = item.text
                            droppedItems.remove(at: index)
                            itemToDelete = nil
                            
                            // Trigger the toast notification here
                            triggerToast("Deleted \"\(deletedTitle)\"")
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        itemToDelete = nil
                    }
                } message: { item in
                    Text("Are you sure you want to delete \"\(item.text)\"?")
                }
        
        
    }
}


struct DroppedItemRow: View {
    let item: DroppedItem
    var onDelete: () -> Void
    
    // Tracks hover state specifically for this individual row
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: item.icon)
                .foregroundStyle(.blue)
            Text(item.text)
            
            Spacer()
            
            // Trash button
            Button(role: .destructive) {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        // Changes background dynamically on hover
        .background(isHovered ? Color.secondary.opacity(0.15) : Color.clear)
        .cornerRadius(6)
        .contentShape(Rectangle())
        // Captures mouse entering/leaving the row bounds
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}
