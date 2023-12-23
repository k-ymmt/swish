//
//  mv.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/13.
//

import Foundation

public func mv(at path: Path, to outputPath: Path) throws {
    try mv(atPath: path.string, toPath: outputPath.string)
}

public func mv(atPath path: String, toPath outputPath: String) throws {
    try FileManager.default.moveItem(atPath: path, toPath: outputPath)
}
