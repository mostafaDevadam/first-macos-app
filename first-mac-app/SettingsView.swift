//
//  SettingsView.swift
//  first-mac-app
//
//  Created by mostafa on 28.09.26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    
    
    // Additional sample settings
        @State private var notificationsEnabled = true
        @State private var username = "Developer"

        var body: some View {
            NavigationStack {
                Form {
                    // PROFILE SECTION
                    Section(header: Text("Account")) {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.accentColor)
                            VStack(alignment: .leading) {
                                Text(username)
                                    .font(.headline)
                                Text("Premium Member")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // APPEARANCE SECTION
                    Section(header: Text("Appearance")) {
                        Toggle(isOn: $isDarkMode) {
                            Label(
                                isDarkMode ? "Dark Mode" : "Light Mode",
                                systemImage: isDarkMode ? "moon.fill" : "sun.max.fill"
                            )
                        }
                        // Tint color updates dynamically based on the state
                        .tint(isDarkMode ? .purple : .orange)
                    }
                    
                    // PREFERENCES SECTION
                    Section(header: Text("Preferences")) {
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    }
                }
                .navigationTitle("App Settings")
            }
        }
}

