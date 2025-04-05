import Foundation
import UIKit

class PomodoroTimerViewModel: ObservableObject {
    @Published var pomodoro: PomodoroSession
    @Published var dailyHistory: [Date : DailyHistory] = [:]
    @Published var selectedCategory: Category? = nil
    @Published var isTimerRunning = false
    
    private var timer: DispatchSourceTimer?
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    private var isTimerPaused = false
    
    init(pomodoro: PomodoroSession) {
        self.pomodoro = pomodoro
        self.pomodoro.focusTime = 1500
        self.pomodoro.breakTime = 300
    }
    
    var sortedHistory: [(Date, DailyHistory)] {
        dailyHistory.sorted(by: { $0.key > $1.key})
    }
    
    var timeRemainingFormatted: String {
        let total = pomodoro.sessionType == .focus ? pomodoro.focusTime : pomodoro.breakTime
        let remaining = max(total - pomodoro.elapsedTime, 0)
        let minute = Int(remaining) / 60
        let second = Int(remaining) % 60
        return String(format: "%02d:%02d", minute, second)
    }
    
    var totalTime: Double {
        let total = pomodoro.sessionType == .focus ? pomodoro.focusTime : pomodoro.breakTime
        return Double(total)
    }
    
    var focusMessage: String {
        pomodoro.sessionType == .focus ? "Focus on your task" : "Break"
    }
    
    func setFocusTime(time: TimeInterval) {
        self.pomodoro.focusTime = time
    }
    
    func setBreakTime(time: TimeInterval) {
        self.pomodoro.breakTime = time
    }
    
    func startTimer() {
        if let existingTimer = timer {
            if isTimerPaused {
                resumeTimer()
            }
            return
        }

        isTimerRunning = true
        isTimerPaused = false

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
        guard isTimerRunning, !isTimerPaused else { return }

        timer?.suspend()
        isTimerRunning = false
        isTimerPaused = true
    }

    func resumeTimer() {
        guard !isTimerRunning, isTimerPaused else { return }

        timer?.resume()
        isTimerRunning = true
        isTimerPaused = false
    }
    
    func stopTimer() {
        if isTimerPaused {
            timer?.resume()
            isTimerPaused = false
        }
        
        timer?.cancel()
        timer = nil
        
        isTimerRunning = false
        pomodoro.elapsedTime = 0
        pomodoro = pomodoro
        
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
            updateHistoryAfterSession()
            stopTimer()
            pomodoro.sessionType = .breakTime
//            pomodoro.elapsedTime = 0
        } else if pomodoro.sessionType == .breakTime && pomodoro.elapsedTime >= pomodoro.breakTime {
            updateHistoryAfterSession()
            stopTimer()
            pomodoro.sessionType = .focus
//            pomodoro.elapsedTime = 0
        }
    }
    
    func setFocusTime(minutes: Int, seconds: Int) {
        pomodoro.focusTime = TimeInterval((minutes * 60) + seconds)
    }
    
    func setBreakTime(minutes: Int, seconds: Int) {
        pomodoro.breakTime = TimeInterval((minutes * 60) + seconds)
    }
    
    
    func updateHistoryAfterSession() {
        let today = Calendar.current.startOfDay(for: Date()) // Strip time component

        if var todayHistory = dailyHistory[today] {
            // Update existing record
            if pomodoro.sessionType == .focus {
                todayHistory.focusTime += Int(pomodoro.elapsedTime)
            } else {
                todayHistory.breakTime += Int(pomodoro.elapsedTime)
            }
            dailyHistory[today] = todayHistory
        } else {
            // No entry for today yet — create one
            if pomodoro.sessionType == .focus {
                dailyHistory[today] = DailyHistory(focusTime: Int(pomodoro.elapsedTime), breakTime: 0)
            } else {
                dailyHistory[today] = DailyHistory(focusTime: 0, breakTime: Int(pomodoro.elapsedTime))
            }
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
