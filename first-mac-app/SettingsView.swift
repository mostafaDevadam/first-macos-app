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
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"

    var body: some View {
           NavigationStack {
               Form {
                   // ACCOUNT SECTION
                   Section(header: Text("account_section_header")) {
                       HStack {
                           Image(systemName: "person.crop.circle.fill")
                               .font(.system(size: 40))
                               .foregroundColor(.accentColor)
                           VStack(alignment: .leading) {
                               Text(username)
                                   .font(.headline)
                               Text("premium_member_subtitle")
                                   .font(.subheadline)
                                   .foregroundColor(.secondary)
                           }
                       }
                   }
                   
                   // APPEARANCE SECTION
                   Section(header: Text("appearance_section_header")) {
                       Toggle(isOn: $isDarkMode) {
                           Label(
                               isDarkMode ? "dark_mode_label" : "light_mode_label",
                               systemImage: isDarkMode ? "moon.fill" : "sun.max.fill"
                           )
                       }
                       .tint(isDarkMode ? .purple : .orange)
                   }
                   
                   
                   
                   // LANGUAGE SECTION (macOS Native)
                   Section(header: Text("language_section_header")) {
                       HStack {
                           Label("language_picker_label", systemImage: "globe")
                           
                           Spacer()
                           
                           Picker("", selection: $selectedLanguage) {
                               Text("English").tag("en")
                               Text("العربية").tag("ar")
                               Text("Deutsch").tag("de")
                           }
                           //.pickerStyle(.menu) // Creates a clean, native macOS dropdown menu
                           //.frame(width: 120)  // Keeps the dropdown neatly sized on the right
                            }
                   }
                   
                   // PREFERENCES SECTION
                   Section(header: Text("preferences_section_header")) {
                       Toggle("enable_notifications_label", isOn: $notificationsEnabled)
                   }
                   
                   Spacer(minLength: 5)
               }
               .navigationTitle("app_settings_title")
           }
       }
}

