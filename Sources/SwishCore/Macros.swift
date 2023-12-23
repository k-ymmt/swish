//
//  Macros.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/10.
//

import Foundation

@freestanding(expression)
public macro URL(stringLiteral: String) = #externalMacro(module: "SwishCoreMacros", type: "URLMacro")

@attached(member, names: named(CodingKeys))
public macro CustomCodingKeys() = #externalMacro(module: "SwishCoreMacros", type: "CustomCodingKeys")

@attached(peer)
public macro CustomCodingKey(name: String) = #externalMacro(module: "SwishCoreMacros", type: "CustomCodingKey")
