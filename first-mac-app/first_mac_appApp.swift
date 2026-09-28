//
//  first_mac_appApp.swift
//  first-mac-app
//
//  Created by mostafa on 06.09.26.
//

import SwiftUI

@main
struct first_mac_appApp: App {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    @AppStorage("selectedLanguage") private var selectedLanguage = "en"
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
                .environment(\.locale, Locale(identifier: selectedLanguage))
        }
    }
}
