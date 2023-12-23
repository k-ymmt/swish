//
//  SwishCorePlugin.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/10.
//

import Foundation
import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwishCorePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        URLMacro.self,
        CustomCodingKeys.self,
        CustomCodingKey.self,
    ]
}
