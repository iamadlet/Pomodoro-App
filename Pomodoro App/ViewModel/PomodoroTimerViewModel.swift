import Foundation
import UIKit

class PomodoroTimerViewModel: ObservableObject {
    @Published var pomodoro: PomodoroSession
    @Published var selectedCategory: Category? = nil
    
    private var timer: DispatchSourceTimer?
    private var isTimerRunning = false
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    
    init(pomodoro: PomodoroSession) {
        self.pomodoro = pomodoro
    }
    
    func setFocusTime(time: TimeInterval) {
        self.pomodoro.focusTime = time
    }
    
    func setBreakTime(time: TimeInterval) {
        self.pomodoro.breakTime = time
    }
    
    func startTimer() {
        guard !isTimerRunning else { return }
        
        isTimerRunning = true
//        pomodoro.elapsedTime = 0
        
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer?.schedule(deadline: .now(), repeating: 1)
        
        timer?.setEventHandler { [weak self] in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.pomodoro.elapsedTime += 1
                
                self.handleTimerCycle()
            }
        }
        
        timer?.resume()
        beginBackgroundTask()
    }
    
    func pauseTimer() {
        guard isTimerRunning else { return }
        
        timer?.suspend()
        isTimerRunning = false;
    }
    
    func resumeTimer() {
        guard !isTimerRunning else { return }
        
        timer?.resume()
        isTimerRunning = true;
    }
    
    func stopTimer() {
        if isTimerRunning {
            timer?.cancel()
            isTimerRunning = false
        }
        
        timer = nil
        endBackgroundTask()
    }
    
    func setCategory(name: Category){
        self.selectedCategory = name
    }
    
//    func getSelectedCategory() -> String {
//        return self.selectedCategory ?? .Others
//    }
    
    private func beginBackgroundTask() {
        backgroundTaskID = UIApplication.shared.beginBackgroundTask() {
            self.endBackgroundTask()
        }
    }
    
    private func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }
    
    private func handleTimerCycle() {
        if pomodoro.sessionType == .focus && pomodoro.elapsedTime >= pomodoro.focusTime {
            pomodoro.sessionType = .breakTime
            pomodoro.elapsedTime = 0
        } else if pomodoro.sessionType == .breakTime && pomodoro.elapsedTime >= pomodoro.breakTime {
            pomodoro.sessionType = .focus
            pomodoro.elapsedTime = 0
        }
    }
    
//    func changeCategory() -> String {
//        
//    }
    
    enum Category: String, CaseIterable {
        case Work
        case Study
        case Workout
        case Reading
        case Meditation
        case Others
        
        var displayName: String {
            switch self {
            case .Work: return "Work"
            case .Study: return "Study"
            case .Workout: return "Workout"
            case .Reading: return "Reading"
            case .Meditation: return "Meditation"
            case .Others: return "Others"
            }
        }
    }
}
