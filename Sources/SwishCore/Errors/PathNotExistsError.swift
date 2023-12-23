//
//  PathNotExistsError.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/24.
//

import Foundation

public struct PathNotExistsError: LocalizedError {
    let path: Path

    public var errorDescription: String? {
        "No such file or directory at \(path)"
    }
}
