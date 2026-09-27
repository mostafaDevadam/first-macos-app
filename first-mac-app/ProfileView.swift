//
//  ProfileView.swift
//  first-mac-app
//
//  Created by mostafa on 20.09.26.
//

import SwiftUI
import MapKit

struct ProfileView: View {
    
    @State private var selectedTab = "Info"
    let tabs = ["Info", "Address", "Company"]
    
    let profileCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
                    
                    // Segmented Tabs
                    Picker("", selection: $selectedTab) {
                        ForEach(tabs, id: \.self) { tab in
                            Text(tab)
                        }
                    }
                    .pickerStyle(.segmented)

                    // Content based on selected tab
                    VStack(alignment: .leading, spacing: 8) {
                        if selectedTab == "Info" {
                            Text("Name: Leanne Graham")
                            Text("Email: Sincere@april.biz")
                        } else if selectedTab == "Address" {
                            Text("City: Gwenborough")
                            Text("Street: Kulas Light")
                            
                            //MapFallbackView()
                            //SimpleProfileMap()
                            SafeMapView(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
                                .frame(height: 220)
                                .cornerRadius(8)
                        } else if selectedTab == "Company" {
                            Text("Company: Romaguera-Crona")
                            Text("Catchphrase: Multi-layered client-server")
                        }
                    }
                    .font(.subheadline)
                    
                    Spacer()
                }
                .padding()
        
        
    }
}


struct MapFallbackView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "map.fill")
                .font(.system(size: 32))
                .foregroundStyle(.secondary)
            Text("Map Preview Unavailable")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.controlBackgroundColor))
        .frame(height: 200)
        .cornerRadius(8)
    }
}


struct ProfileMapContainer: View {
    let coordinate: CLLocationCoordinate2D
    @State private var region: MKCoordinateRegion

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }
    
    let profileCoordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)

    var body: some View {
        ZStack {
            // Background container frame
            Color(NSColor.controlBackgroundColor)
            
            // Native Map View
            SafeMapView(coordinate: profileCoordinate)
                            .frame(height: 220)        // Crucial: Gives the map a visible height
                            .cornerRadius(8)           // Rounds the corners nicely
                            .shadow(radius: 2)
        }
        .frame(height: 220)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }
}
