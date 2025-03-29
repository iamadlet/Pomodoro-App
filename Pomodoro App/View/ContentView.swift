//
//  ContentView.swift
//  Pomodoro App
//
//  Created by Адлет Жумагалиев on 29.03.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Label("Main", systemImage: "house")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "doc")
                }
        }
    }
}

#Preview {
    ContentView()
}
