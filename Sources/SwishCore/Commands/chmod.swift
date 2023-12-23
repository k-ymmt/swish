//
//  chmod.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/13.
//

import Foundation

public func chmod(permission: Int, path: String) throws {
    try FileManager.default.setAttributes([.posixPermissions: permission], ofItemAtPath: path)
}

public func chmod(permission: Int, path: Path) throws {
    try chmod(permission: permission, path: path.string)
}
