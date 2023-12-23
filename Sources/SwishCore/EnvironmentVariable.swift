//
//  EnvironmentVariable.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/13.
//

import Foundation

public struct EnvironmentVariable {
    fileprivate init() {
    }

    public subscript(_ name: String) -> String? {
        get {
            name.withCString { pointer in
                guard let raw = getenv(pointer) else {
                    return nil
                }
                return String(cString: raw)
            }
        }
        set {
            setenv(name, newValue, 1)
        }
    }
}

public var env: EnvironmentVariable = .init()

public extension EnvironmentVariable {
    enum SwishKeys {
        public static let executeFilePath = "SWISH_EXECUTE_FILE_PATH"
        public static let configuration = "SWISH_CONFIGURATION"
    }
}
