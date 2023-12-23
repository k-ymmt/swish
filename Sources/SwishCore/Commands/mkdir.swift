//
//  mkdir.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/13.
//

import Foundation

public func mkdir(
    at path: Path,
    withIntermediateDirectories createIntermediates: Bool = true,
    attributes: [FileAttributeKey: Any]? = nil
) throws {
    try mkdir(atPath: path.string, withIntermediateDirectories: createIntermediates, attributes: attributes)
}

public func mkdir(
    atPath path: String,
    withIntermediateDirectories createIntermediates: Bool = true,
    attributes: [FileAttributeKey: Any]? = nil
) throws {
    try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: createIntermediates, attributes: attributes)
}
