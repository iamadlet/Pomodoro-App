import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: PomodoroTimerViewModel
    @State var focusTime: Date
    @State var breakTime: Date
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            VStack {
                Text("Settings")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                
                TimePickerView(viewModel: viewModel)
                
                Spacer()
            }
        }
    }
}

#Preview {
    SettingsView(viewModel: mockViewModel, focusTime: Date.now, breakTime: Date.now)
}
