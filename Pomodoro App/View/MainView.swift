import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: PomodoroTimerViewModel
    @Binding var bgImage: String
    @State var showingCategories = false
    
    var body: some View {
        ZStack {
            Image(bgImage)
                .resizable()
                .ignoresSafeArea()
            VStack {
                //MARK: - Focus Category Button
                Button(action: {
                    showingCategories.toggle()
                }, label: {
                    Text(viewModel.selectedCategory?.displayName ?? "Focus Category")
                        .frame(width: 160, height: 36)
                        .background(.gray.opacity(0.5))
                        .cornerRadius(16)
                        .font(.system(size: 16))
                        .foregroundStyle(Color.white)
                })
                .sheet(isPresented: $showingCategories, content: {
                    CategorySheetView(showingCategories: $showingCategories, viewModel: viewModel)
                        .presentationDetents([.height(300)])
                })
                
                //MARK: - Timer Circle
                ZStack {
                    Circle()
                        .stroke(lineWidth: 6)
                        .foregroundStyle(.gray.opacity(0.5))
                        .frame(width: 248, height: 264)
                    
                    Circle()
                        .trim(from: 0.0, to: viewModel.pomodoro.elapsedTime / viewModel.totalTime)
                        .stroke(lineWidth: 6)
                        .rotationEffect(.degrees(-90))
                        .foregroundStyle(.white)
                        .frame(width: 248, height: 264)
                    
                    VStack(spacing: 8) {
                        Text("\(viewModel.timeRemainingFormatted)")
                            .font(.system(size: 44, weight: .bold))
                            .foregroundStyle(.white)
                        
                        Text(viewModel.focusMessage)
                            .font(.system(size: 16))
                            .foregroundStyle(.white)
                    }
                }
                .padding(.bottom, 60)
                //MARK: - Pause/Resume & Stop Buttons
                HStack(spacing: 80) {
                    if viewModel.isTimerRunning {
                        TimerButton(systemImageName: "pause", action: viewModel.pauseTimer)
                    } else {
                        TimerButton(systemImageName: "play", action: viewModel.startTimer)                        
                    }
                    
                    TimerButton(systemImageName: "stop.fill", action: viewModel.stopTimer)
                }
            }
        }
    }
}

#Preview {
    MainView(viewModel: mockViewModel, bgImage: .constant("bg1"))
}
