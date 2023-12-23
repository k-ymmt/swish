//
//  open.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/23.
//

import Foundation
import SwishCore

#if canImport(AppKit)
import AppKit

public func `open`(at path: Path) async throws {
    let configuration = NSWorkspace.OpenConfiguration()
    try await NSWorkspace.shared.open(path.url, configuration: configuration)
}

public func `open`(at paths: [Path], withApplicationAt applicationPath: Path) async throws {
    let configuration = NSWorkspace.OpenConfiguration()
    try await NSWorkspace.shared.open(paths.map(\.url), withApplicationAt: applicationPath.url, configuration: configuration)
}

public func `open`(at paths: Path..., withApplicationAt applicationPath: Path) async throws {
    try await open(at: paths, withApplicationAt: applicationPath)
}
#endif
