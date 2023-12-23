//
//  ShellError.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/23.
//

import Foundation

public enum ShellError: LocalizedError, CustomStringConvertible {
    case invalidOutputDataEncoding(Data)
    case invalidInputDataEncoding(String, String.Encoding)
    case uncaughtSignal(Int32)
    case commandFailed(Int32)

    public var errorDescription: String {
        switch self {
        case .invalidOutputDataEncoding(let data):
            "Output data is not UTF-8: \(data.map(String.init).joined(separator: " "))"
        case .invalidInputDataEncoding(let input, let encoding):
            "Input data can't encoding \(encoding): \(input)"
        case .uncaughtSignal(let signal):
            "uncaught signal: \(signal)"
        case .commandFailed(let code):
            "command failed: exit code \(code)"
        }
    }

    public var description: String {
        errorDescription
    }
}
