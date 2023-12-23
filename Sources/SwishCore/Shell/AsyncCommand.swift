//
//  AsyncCommand.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/14.
//

import Foundation

prefix operator %

@discardableResult
public prefix func %(string: String) async throws -> String {
    let (stream, _) = sh(string)
    var result: [String] = []
    for try await output in stream.compactMap(\.output) {
        result.append(output)
    }

    return result.joined(separator: "\n")
}
