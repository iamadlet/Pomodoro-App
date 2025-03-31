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
    var body: some View {
        TabView {
            MainView(viewModel: viewModel, bgImage: $bgImage)
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
