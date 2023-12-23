//
//  Shell.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/23.
//

import Foundation
import Crayon

public struct Shell {
    private let process: Process
    private let stdin: Pipe

    init(process: Process, stdin: Pipe) {
        self.process = process
        self.stdin = stdin
    }


    public var isRunning: Bool {
        process.isRunning
    }

    public var terminationStatus: Int32 {
        process.terminationStatus
    }

    public var processIdentifier: Int32 {
        process.processIdentifier
    }

    public func terminate() {
        process.terminate()
    }

    public func waitUntilExit() {
        process.waitUntilExit()
    }

    public func write(_ data: Data) throws {
        try stdin.fileHandleForWriting.write(contentsOf: data)
    }
}

public func shell(
    _ executablePath: Path,
    arguments: [String] = [],
    currentDirectory: Path? = nil,
    environment: [String: String]? = nil
) -> (stream: AsyncThrowingStream<ShellOutput, any Error>, shell: Shell) {
    let (stream, continuation) = AsyncThrowingStream<ShellOutput, any Error>.makeStream()
    let process = Process()
    process.executableURL = executablePath.url
    process.arguments = arguments

    let stdout = Pipe()
    stdout.fileHandleForReading.waitForDataInBackgroundAndNotify()
    stdout.fileHandleForReading.readabilityHandler = { handle in
        let data = handle.availableData
        guard
            !data.isEmpty,
            let string = String(data: data, encoding: .utf8)
        else {
            return
        }

        continuation.yield(.output(string))
    }
    let stderr = Pipe()
    stderr.fileHandleForReading.waitForDataInBackgroundAndNotify()
    stderr.fileHandleForReading.readabilityHandler = { handle in
        let data = handle.availableData
        guard
            !data.isEmpty,
            let string = String(data: data, encoding: .utf8)
        else {
            return
        }

        continuation.yield(.error(string))
    }
    let stdin = Pipe()

    process.standardOutput = stdout
    process.standardError = stderr
    process.standardInput = stdin
    if let currentDirectory {
        process.currentDirectoryURL = currentDirectory.url
    }
    if let environment {
        process.environment = environment
    }
    process.terminationHandler = { process in
        let terminationStatus = process.terminationStatus
        let error: ShellError? = switch process.terminationReason {
        case .exit where terminationStatus == 0:
            nil
        case .exit:
            .commandFailed(terminationStatus)
        case .uncaughtSignal:
            .uncaughtSignal(terminationStatus)
        @unknown default:
            .commandFailed(terminationStatus)
        }

        continuation.finish(throwing: error)
    }
    continuation.onTermination = { _ in
        if process.isRunning {
            process.terminate()
        }
    }

    do {
        try process.run()
    } catch {
        continuation.finish(throwing: error)
    }
    return (stream, Shell(process: process, stdin: stdin))
}

public func sh(
    _ arguments: [String],
    currentDirectory: Path? = nil,
    environment: [String: String]? = nil
) -> (stream: AsyncThrowingStream<ShellOutput, any Error>, shell: Shell) {
    return shell("/bin/sh", arguments: CollectionOfOne("-c") + arguments, currentDirectory: currentDirectory, environment: environment)
}

public func sh(
    _ arguments: String...,
    currentDirectory: Path? = nil,
    environment: [String: String]? = nil
) -> (stream: AsyncThrowingStream<ShellOutput, any Error>, shell: Shell) {
    return shell("/bin/sh", arguments: CollectionOfOne("-c") + arguments, currentDirectory: currentDirectory, environment: environment)
}

public func bash(
    _ arguments: [String],
    currentDirectory: Path? = nil,
    environment: [String: String]? = nil
) -> (stream: AsyncThrowingStream<ShellOutput, any Error>, shell: Shell) {
    return shell("/bin/bash", arguments: CollectionOfOne("-c") + arguments, currentDirectory: currentDirectory, environment: environment)
}

public func zesh(
    _ arguments: [String],
    currentDirectory: Path? = nil,
    environment: [String: String]? = nil
) -> (stream: AsyncThrowingStream<ShellOutput, any Error>, shell: Shell) {
    return shell("/bin/zesh", arguments: CollectionOfOne("-c") + arguments, currentDirectory: currentDirectory, environment: environment)
}

public extension Shell {
    func write(_ string: String, encoding: String.Encoding = .utf8) throws {
        guard let data = string.data(using: encoding) else {
            throw ShellError.invalidInputDataEncoding(string, encoding)
        }
        try self.write(data)
    }
}
