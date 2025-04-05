//
//  TimePickerView.swift
//  Pomodoro App
//
//  Created by Адлет Жумагалиев on 05.04.2025.
//

import SwiftUI

struct TimePickerView: View {
    @ObservedObject var viewModel: PomodoroTimerViewModel
    
    @State private var focusTimeText: String = ""
    @State private var breakTimeText: String = ""
    
    var body: some View {
        //MARK: - minutes picker
        VStack {
            HStack {
                Text("Focus Time")
                
                Spacer()
                
                TextField("25:00", text: $focusTimeText)
                    .frame(width: 60)
                    .keyboardType(.numbersAndPunctuation)
                    .onChange(of: focusTimeText) { newValue in
                        if let interval = parseTimeString(newValue) {
                            viewModel.setFocusTime(time: interval)
                        }
                    }
                
            }
            
            Divider()
            
            HStack {
                Text("Break Time")
                
                Spacer()
                
                TextField("05:00", text: $breakTimeText)
                    .frame(width: 60)
                    .keyboardType(.numbersAndPunctuation)
                    .onChange(of: breakTimeText) { newValue in
                        if let interval = parseTimeString(newValue) {
                            viewModel.setBreakTime(time: interval)
                        }
                    }
            }
            
            Divider()
            
        }
        .foregroundStyle(.white)
        .font(.system(size: 17, weight: .medium))
        .padding(20)
        .onAppear {
            focusTimeText = formatTime(viewModel.pomodoro.focusTime)
            breakTimeText = formatTime(viewModel.pomodoro.breakTime)
        }
        
        
    }
    
    func parseTimeString(_ text: String) -> TimeInterval? {
        let parts = text.split(separator: ":").map { String($0) }
        guard parts.count == 2,
              let minutes = Int(parts[0]),
              let seconds = Int(parts[1]),
              minutes >= 0, seconds >= 0, seconds < 60 else {
            return nil
        }
        return TimeInterval(minutes * 60 + seconds)
    }
    
    func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    TimePickerView(viewModel: mockViewModel)
}
