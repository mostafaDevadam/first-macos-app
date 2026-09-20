//
//  ProfileView.swift
//  first-mac-app
//
//  Created by mostafa on 20.09.26.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var selectedTab = "Info"
    let tabs = ["Info", "Address", "Company"]
    
    
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
