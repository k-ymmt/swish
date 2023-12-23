//
//  ShellOutput.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/23.
//

import Foundation

public enum ShellOutput {
    case output(String)
    case error(String)
}

public extension ShellOutput {
    var output: String? {
        guard case let .output(string) = self else {
            return nil
        }
        return string
    }
    var error: String? {
        guard case let .error(string) = self else {
            return nil
        }
        return string
    }
}

extension ShellOutput: CustomStringConvertible {
    public var description: String {
        switch self {
        case .output(let output):
            output
        case .error(let error):
            Crayon.red(error).string
        }
    }
}
