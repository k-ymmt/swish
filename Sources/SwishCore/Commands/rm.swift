//
//  rm.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/13.
//

import Foundation

public func rm(at path: Path) throws {
    try rm(atPath: path.string)
}

public func rm(atPath path: String) throws {
    try FileManager.default.removeItem(atPath: path)
}
