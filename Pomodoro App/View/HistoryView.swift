import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: PomodoroTimerViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            VStack {
                Text("History")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                ForEach(viewModel.sortedHistory, id: \.0) { date, stats in
                    Section {
                        let fHours = stats.focusTime / 3600
                        let fMinutes = (stats.focusTime - (fHours * 3600)) / 60
                        let fSeconds = stats.focusTime % 60
                        
                        let bHours = stats.breakTime / 3600
                        let bMinutes = (stats.breakTime - (bHours * 3600)) / 60
                        let bSeconds = stats.breakTime % 60
                        Text(date.formatted(.dateTime.day().month().year()))
                        
                        HStack {
                            Text("Focus Time")
                            Spacer()
                            Text(String(format: "%02d:%02d:%02d", fHours, fMinutes, fSeconds))
                        }
                        .padding()
                        
                        Divider()
                        
                        HStack {
                            Text("Break Time")
                            Spacer()
                            Text(String(format: "%02d:%02d:%02d", bHours, bMinutes, bSeconds))
                        }
                        .padding()
                        
                        Divider()
                    }
                    Spacer()
                }
            }
            .foregroundStyle(.white)
            .font(.system(size: 17, weight: .medium))
        }
    }
}

#Preview {
    HistoryView(viewModel: mockViewModel)
}
