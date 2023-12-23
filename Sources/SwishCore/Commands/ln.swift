//
//  ln.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/13.
//

import Foundation

public enum LinkType {
    case hard
    case soft
}

public func ln(at srcPath: Path, to destPath: Path, linkType: LinkType = .soft) throws {
    try ln(atPath: srcPath.string, toPath: destPath.string, linkType: linkType)
}

public func ln(at srcPath: Path, toPath destPath: String, linkType: LinkType = .soft) throws {
    try ln(atPath: srcPath.string, toPath: destPath, linkType: linkType)
}

public func ln(atPath srcPath: String, to destPath: Path, linkType: LinkType = .soft) throws {
    try ln(atPath: srcPath, toPath: destPath.string, linkType: linkType)
}

public func ln(atPath srcPath: String, toPath destPath: String, linkType: LinkType = .soft) throws {
    switch linkType {
    case .hard:
        try FileManager.default.linkItem(atPath: srcPath, toPath: destPath)
    case .soft:
        try FileManager.default.createSymbolicLink(atPath: srcPath, withDestinationPath: destPath)
    }
}
