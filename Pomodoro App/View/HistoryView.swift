import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: PomodoroTimerViewModel
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            VStack {
                ForEach(viewModel.history) { date in
                    
                }
            }
        }
    }
}

#Preview {
    HistoryView(viewModel: mockViewModel)
}
