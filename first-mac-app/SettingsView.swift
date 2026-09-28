//
//  SettingsView.swift
//  first-mac-app
//
//  Created by mostafa on 28.09.26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    
    
    var body: some View {
        Form {
                   Section(header: Text("Appearance")) {
                       Toggle(isOn: $isDarkMode) {
                           Label(
                               isDarkMode ? "Dark Mode" : "Light Mode",
                               systemImage: isDarkMode ? "moon.fill" : "sun.max.fill"
                           )
                       }
                   }
               }
    }
}

