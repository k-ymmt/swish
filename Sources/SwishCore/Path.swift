//
//  Path.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/10.
//

import Foundation

enum PathError {
    enum InvalidEncoding: LocalizedError {
        case data(Data)
        case string(String)

        var errorDescription: String {
            "This data is not encoded UTF-8: \(string)"
        }

        private var string: String {
            switch self {
            case .data(let data):
                data.map(String.init).joined(separator: " ")
            case .string(let string):
                string
            }
        }
    }
}

public struct Path {
    public let url: URL
    public let string: String

    public init(url: URL) {
        self.url = url
        self.string = url.path(percentEncoded: false)
    }

    public init(string: String) {
        self.url = URL(filePath: string)
        self.string = string
    }
}

public extension Path {
    static let root: Path = Path(string: "/")
    static var executeFile: Path {
        guard let path = env["SWISH_EXECUTE_FILE_PATH"] else {
            fatalError("Path.executeFile is neccessary SWISH_EXECUTE_FILE_PATH environment. please set variable.")
        }
        return Path(string: path)
    }
    static var current: Path {
        Path(url: .currentDirectory())
    }
    static var temporary: Path {
        Path(url: .temporaryDirectory)
    }
    static var home: Path {
        Path(url: .homeDirectory)
    }
    static var cache: Path {
        Path(url: .cachesDirectory)
    }
    static var application: Path {
        Path(url: .applicationDirectory)
    }
    static var library: Path {
        Path(url: .libraryDirectory)
    }
    static var user: Path {
        Path(url: .userDirectory)
    }
    static var documents: Path {
        Path(url: .documentsDirectory)
    }
    static var desktop: Path {
        Path(url: .desktopDirectory)
    }
    static var applicationSupport: Path {
        Path(url: .applicationSupportDirectory)
    }
    static var download: Path {
        Path(url: .downloadsDirectory)
    }
    static var movies: Path {
        Path(url: .moviesDirectory)
    }
    static var music: Path {
        Path(url: .musicDirectory)
    }
    static var pictures: Path {
        Path(url: .picturesDirectory)
    }
    static var trash: Path {
        Path(url: .trashDirectory)
    }

    var isAbsolute: Bool {
        string.first == "/"
    }

    var isRoot: Bool {
        url.standardizedFileURL.path(percentEncoded: false) == "/"
    }

    var isDirectory: Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: string, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    var isFile: Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: string, isDirectory: &isDirectory)
        return exists && !isDirectory.boolValue
    }

    var exists: Bool {
        FileManager.default.fileExists(atPath: string)
    }

    var dirname: String {
        url.deletingLastPathComponent().path(percentEncoded: false)
    }

    var dirpath: Path {
        Path(string: dirname)
    }

    var basename: String {
        url.lastPathComponent
    }

    var basenameWithoutExtension: String {
        url.deletingPathExtension().lastPathComponent
    }

    var isReadable: Bool {
        FileManager.default.isReadableFile(atPath: string)
    }

    var standardized: Path {
        Path(url: url.standardizedFileURL)
    }

    func appending(path: Path) -> Path {
        Path(url: url.appending(path: path.string))
    }

    func appending(string: String) -> Path {
        appending(path: Path(string: string))
    }

    mutating func append(path: Path) {
        self = appending(path: path)
    }

    mutating func append(string: String) {
        self = appending(string: string)
    }

    func resolvingSymbolicLink() -> Path {
        Path(url: url.resolvingSymlinksInPath())
    }

    func contains(_ path: Path) -> Bool {
        string.contains(path.string)
    }

    func contains(_ string: String) -> Bool {
        string.contains(string)
    }
}

public extension Path {
    static func >>(data: Data, path: Path) throws {
        try createFile(data: data, path: path, append: true)
    }

    static func >>(string: String, path: Path) throws {
        guard let data = string.data(using: .utf8) else {
            throw PathError.InvalidEncoding.string(string)
        }

        try data >> path
    }

    static func >(data: Data, path: Path) throws {
        try createFile(data: data, path: path, append: false)
    }

    static func >(string: String, path: Path) throws {
        guard let data = string.data(using: .utf8) else {
            throw PathError.InvalidEncoding.string(string)
        }

        try data > path
    }

    static func createFile(data: Data, path: Path, append: Bool) throws {
        guard let stream = OutputStream(url: path.url, append: append) else {
            return
        }
        stream.open()
        defer { stream.close() }

        _ = data.withUnsafeBytes { p in
            stream.write(p.baseAddress!, maxLength: data.count)
        }

        if let error = stream.streamError {
            throw error
        }
    }

    static func +(lhs: Path, rhs: Path) -> Path {
        lhs.appending(path: rhs)
    }

    static func +(lhs: Path, rhs: String) -> Path {
        lhs.appending(string: rhs)
    }
}

extension Path: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(string: value)
    }
}

extension Path: CustomStringConvertible {
    public var description: String {
        url.standardizedFileURL.path(percentEncoded: false)
    }
}

extension Path: Equatable {
    public static func ==(lhs: Path, rhs: Path) -> Bool {
        lhs.string == rhs.string
    }
}

public extension Data {
    init(contentsOf path: Path, options: ReadingOptions = []) throws {
        try self.init(contentsOf: path.url, options: options)
    }
}
