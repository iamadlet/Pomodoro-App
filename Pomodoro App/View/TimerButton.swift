//
//  TimerButton.swift
//  Pomodoro App
//
//  Created by Адлет Жумагалиев on 01.04.2025.
//

import SwiftUI

struct TimerButton: View {
    let systemImageName: String
    let action: () -> Void
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 56, height: 56)
                .foregroundColor(.gray.opacity(0.5))
                .padding(.trailing, 5)
            Button(action: action) {
                Image(systemName: systemImageName)
                    .resizable()
                    .frame(width: 18, height: 20)
                    .foregroundColor(.white)
            }
            
        }
    }
}

//#Preview {
//    TimerButton(systemImageName: <#T##String#>, action: <#T##() -> Void#>)
//}
