//
//  cd.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation

enum ChangeDirectoryError {
    struct DirectoryNotExists: LocalizedError {
        let path: Path

        var errorDescription: String {
            "This directory not exists: \(path)"
        }
    }

    struct Unknown: LocalizedError {
        let path: Path

        var errorDescription: String {
            "Change directory failed: \(path)"
        }
    }
}

public func cd(_ path: Path) throws {
    if !FileManager.default.changeCurrentDirectoryPath(path.string) {
        if !path.exists {
            throw ChangeDirectoryError.DirectoryNotExists(path: path)
        }
        throw ChangeDirectoryError.Unknown(path: path)
    }
}
