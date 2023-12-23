//
//  makeFile.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/13.
//

import Foundation

public func makeFile(at path: Path, contents: Data? = nil, attributes: [FileAttributeKey: Any]? = nil) throws {
    FileManager.default.createFile(atPath: path.string, contents: contents, attributes: attributes)
}

public func makeFile(at path: Path, contents: String, attributes: [FileAttributeKey: Any]? = nil) throws {
    try makeFile(at: path, contents: contents.data(using: .utf8), attributes: attributes)
}
