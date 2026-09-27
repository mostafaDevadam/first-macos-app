//
//  SimpleChartView.swift
//  first-mac-app
//
//  Created by mostafa on 27.09.26.
//

import SwiftUI
import Charts

struct LibraryStat: Identifiable {
    let id = UUID()
    let category: String
    let count: Int
}


struct SimpleChartView: View {
    let stats: [LibraryStat] = [
            .init(category: "Musics", count: 12),
            .init(category: "Videos", count: 5),
            .init(category: "Notes", count: 18),
            .init(category: "Todos", count: 8),
            .init(category: "Posts", count: 4)
        ]
    
    
    var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("Library Overview")
                    .font(.title2)
                    .bold()
                
                // Simple Bar Chart Container
                Chart(stats) { stat in
                    BarMark(
                        x: .value("Category", stat.category),
                        y: .value("Count", stat.count)
                    )
                    .foregroundStyle(by: .value("Category", stat.category))
                    .cornerRadius(6)
                }
                .frame(height: 250)
                .padding()
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(12)
                .shadow(radius: 1)
                
            }
            .padding(20)
        }
}

