//
//  URLMacroTests.swift
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
#endif

final class URLMacroTests: XCTestCase {
    func testSimple() throws {
#if canImport(SwishCoreMacros)
        assertMacroExpansion(
            """
            #URL(stringLiteral: "https://example.com")
            """,
            expandedSource: """
            URL(string: "https://example.com")!
            """,
            macros: testMacros
        )
#endif
    }
}
