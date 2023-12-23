//
//  PathGenerator.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/15.
//

import Foundation
import SwishCore

enum PathGenerator {
    static let defaultLibPath = PathGenerator.swishProjectDir() + ".build/release"
    static let defaultBinPath = PathGenerator.swishProjectDir() + ".build/release/swish"

    static func makeProjectDirPath(filePath: Path) -> Path {
        let cachePath = Path.cache + "swish"
        let parentDir = cachePath + PathGenerator.makeProjectDirName(filePath: filePath)
        let fileName = filePath.basenameWithoutExtension
        return parentDir + fileName
    }

    static func makeProjectDirName(filePath: Path) -> String {
        let filePath = if filePath.isAbsolute {
            filePath.dirpath
        } else {
            Path.current + filePath.dirpath
        }
        return String(filePath.url
            .standardizedFileURL
            .path(percentEncoded: false)
            .dropFirst()
            .replacing("/", with: "-"))
    }

    static func makeCacheSwiftFilePath(filePath: Path) -> Path {
        makeProjectDirPath(filePath: filePath) + ".build/swish/\(filePath.basename)_sha256"
    }

    static func swishProjectDir() -> Path {
        Path(string: "\(#filePath)/../../../").standardized
    }
}
