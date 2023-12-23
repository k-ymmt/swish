//
//  Logger.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/14.
//

import Foundation
import Crayon

public func debug(_ message: @autoclosure () -> String, file: String = #fileID, function: String = #function, line: Int = #line) {
    Logger.debug(message(), file: file, function: function, line: line)
}

public func debug(_ message: @autoclosure () -> Any?, file: String = #file, function: String = #function, line: Int = #line) {
    Logger.debug(message(), file: file, function: function, line: line)
}

public struct Logger {
    public enum Level: Int {
        case debug = 0
        case info
        case error
    }

    public static var level: Level = makeLevelFromEnv()

    public static func debug(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), logLevel: .debug, file: file, function: function, line: line)
    }

    public static func info(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), logLevel: .info, file: file, function: function, line: line)
    }

    public static func error(_ message: @autoclosure () -> String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message(), logLevel: .error, file: file, function: function, line: line)
    }

    public static func log(_ message: @autoclosure () -> String, logLevel: Level, file: String = #file, function: String = #function, line: Int = #line) {
        guard logLevel.rawValue >= level.rawValue else {
            return
        }
        let header = Crayon.foreground("\(logLevel)[\(format(.now))] \(function): L\(line) in \(file)>", hex: "#808080")
        let output = "\(header) \(message())\n"
        echo(output)
    }
}

public extension Logger {
    static func debug(_ message: @autoclosure () -> Any?, file: String = #file, function: String = #function, line: Int = #line) {
        log(String(describing: message() ?? "nil"), logLevel: .debug, file: file, function: function, line: line)
    }

    static func info(_ message: @autoclosure () -> Any?, file: String = #file, function: String = #function, line: Int = #line) {
        log(String(describing: message() ?? "nil"), logLevel: .info, file: file, function: function, line: line)
    }

    static func error(_ message: @autoclosure () -> any Error, file: String = #file, function: String = #function, line: Int = #line) {
        log(String(describing: message()), logLevel: .error, file: file, function: function, line: line)
    }
}

private let formatter: ISO8601DateFormatter = {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withYear, .withMonth, .withDay, .withFullTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
    return formatter
}()
private func format(_ date: Date) -> String {
    formatter.string(from: date)
}

private func makeLevelFromEnv() -> Logger.Level {
    switch env[EnvironmentVariable.SwishKeys.configuration] {
    case "debug":
        .debug
    default:
        .info
    }
}

extension Logger.Level: CustomStringConvertible {
    public var description: String {
        switch self {
        case .debug:
            "Debug"
        case .info:
            "Info"
        case .error:
            "Error"
        }
    }
}
