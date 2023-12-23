//
//  ls.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/12.
//

import Foundation

struct LsOptions: OptionSet {
    let rawValue: UInt

    static let producesAbsolutePaths = LsOptions(rawValue: 1 << 0)
}

func ls(at path: Path, options: LsOptions = []) throws -> [Path] {
    try ls(at: path.url, options: options)
        .map(Path.init(url:))
}

func ls(atPath path: String, options: LsOptions = []) throws -> [String] {
    try ls(at: URL(filePath: path), options: options)
        .map { $0.path(percentEncoded: false) }
}

func ls(at url: URL = .currentDirectory(), options: LsOptions = []) throws -> [URL] {
    try FileManager.default.contentsOfDirectory(
        at: url,
        includingPropertiesForKeys: nil,
        options: makeContentsOfDirectoryOptions(from: options)
    )
}

private func makeContentsOfDirectoryOptions(from options: LsOptions) -> FileManager.DirectoryEnumerationOptions {
    var newOptions: FileManager.DirectoryEnumerationOptions = []
    if !options.contains(.producesAbsolutePaths) {
        newOptions.insert(.producesRelativePathURLs)
    }

    return newOptions
}
