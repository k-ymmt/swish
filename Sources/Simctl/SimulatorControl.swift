//
//  SimulatorControl.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation
import SwishCore

#if os(macOS)
public struct SimulatorControl {
    public static let `default`: SimulatorControl = .init(command: "xcrun simctl")
    public let command: String

    public init(command: String) {
        self.command = command
    }

    public func list(options: ListOptions = []) async throws -> List {
        var arguments: [String] = []
        if options.contains(.booted) {
            arguments.append("booted")
        }
        if options.contains(.available) {
            arguments.append("available")
        }
        let list = try await run("list \(arguments.joined(separator: " ")) -j")
        let decoder = JSONDecoder()
        return try decoder.decode(List.self, from: list.data(using: .utf8)!)
    }

    public func listApps(uuid: String = "booted") async throws -> [String: App] {
        let result = try await run("listapps \(uuid)")

        guard let data = result.data(using: .utf8) else {
            return [:]
        }

        return try PropertyListDecoder().decode([String: App].self, from: data)
    }

    public func push(device: String = "booted", bundleIdentifier: String? = nil, contents: PushJSONContents) async throws {
        try await run("push \(device) \(bundleIdentifier ?? "") \(contents.makeFileIfNeeded())")
    }

    public func push(device: String = "booted", bundleIdentifier: String? = nil, payload: ApsPayload) async throws {
        try await Task.detached {
            let encoded = try JSONEncoder().encode(payload)
            try await push(device: device, bundleIdentifier: bundleIdentifier, contents: .data(encoded))
        }.value
    }
}

public extension SimulatorControl {
    struct ListOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let booted: Self = .init(rawValue: 1 << 0)
        public static let available: Self = .init(rawValue: 1 << 1)
        public static let deviceTypes: Self = .init(rawValue: 1 << 2)
        public static let runtimes: Self = .init(rawValue: 1 << 3)
        public static let devices: Self = .init(rawValue: 1 << 4)
        public static let pairs: Self = .init(rawValue: 1 << 5)
    }

    enum PushJSONContents {
        case file(Path)
        case string(String)
        case data(Data)
    }
}

private extension SimulatorControl {
    @discardableResult
    func run(_ arguments: String) async throws -> String {
        try await %"\(command) \(arguments)"
    }
}

private extension SimulatorControl.PushJSONContents {
    func makeFileIfNeeded() throws -> Path {
        func makeFile(contents: Data) throws -> Path {
            let filePath = Path.temporary
                .appending(string: UUID().uuidString + String(describing: Date().timeIntervalSince1970))
            try contents > filePath
            return filePath
        }
        switch self {
        case .file(let path):
            return path
        case .string(let string):
            return try makeFile(contents: string.data(using: .utf8)!)
        case .data(let data):
            return try makeFile(contents: data)
        }
    }
}
#endif
