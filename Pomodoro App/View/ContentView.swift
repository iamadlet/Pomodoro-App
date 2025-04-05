//
//  ContentView.swift
//  Pomodoro App
//
//  Created by Адлет Жумагалиев on 29.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PomodoroTimerViewModel(pomodoro: PomodoroSession(focusTime: 1500, breakTime: 300, state: .paused, sessionType: .focus))
    @State var bgImage: String = "bg1"
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor.white // <- inactive item color
    }
    
    var body: some View {
        TabView {
            MainView(viewModel: viewModel, bgImage: $bgImage)
                .tabItem {
                    Label("Main", systemImage: "house")
                }
            
            SettingsView(viewModel: viewModel, focusTime: Date.now, breakTime: Date.now)
                .tabItem {
                    Label("Settings", systemImage: "slider.horizontal.3")
                }
            
            HistoryView(viewModel: viewModel)
                .tabItem {
                    Label("History", systemImage: "doc")
                }
        }
        .accentColor(.gray)
    }
}

#Preview {
    ContentView()
}
