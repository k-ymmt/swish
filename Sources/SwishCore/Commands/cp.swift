//
//  cp.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/14.
//

import Foundation

public func cp(at path: Path, to destPath: Path) throws {
    let path = path.resolvingSymbolicLink()
    var destPath = destPath
    if destPath.isDirectory || destPath.string.hasSuffix("/") {
        destPath = destPath + path.basename
    }
    if destPath.exists {
        try rm(at: destPath)
    }
    try FileManager.default.copyItem(at: path.url, to: destPath.url)

}

public func cp(at paths: [Path], to destPath: Path) throws {
    for path in paths {
        let destPath = destPath + path.basename
        if destPath.exists {
            try rm(at: destPath)
        }
        try FileManager.default.copyItem(at: path.url, to: destPath.url)
    }
}
