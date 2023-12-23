//
//  URLMacro.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/10.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SimpleError: LocalizedError {
    let message: String

    public var errorDescription: String {
        message
    }
}

public enum URLMacro {
}

extension URLMacro: ExpressionMacro {
    public static func expansion(of node: some FreestandingMacroExpansionSyntax, in context: some MacroExpansionContext) throws -> ExprSyntax {
        guard
            let expression = node.argumentList.map(\.expression).first,
            let segments = expression.as(StringLiteralExprSyntax.self)?.segments,
            segments.count == 1,
            case .stringSegment(let segment) = segments.first
        else {
            throw SimpleError(message: "#URL requires a static string literal")
        }

        guard URL(string: segment.content.text) != nil else {
            throw SimpleError(message: "Can't parse URL: \(expression)")
        }

        return "URL(string: \(expression))!"
    }
}
