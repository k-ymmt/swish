//
//  Macros.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/10.
//

import Foundation
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(SwishCoreMacros)
import SwishCoreMacros

let testMacros: [String: Macro.Type] = [
    "URL": URLMacro.self,
]
#endif
