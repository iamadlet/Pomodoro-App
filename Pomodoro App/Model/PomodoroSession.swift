import Foundation

struct PomodoroSession {
    var elapsedTime: TimeInterval = 0
    var focusTime: TimeInterval
    var breakTime: TimeInterval
    var state: TimerState
    var sessionType: SessionType
}

enum TimerState {
    case running
    case paused
    case completed
}

enum SessionType {
    case focus
    case breakTime
}
