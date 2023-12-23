//
//  PathTests.swift
//
//
//  Created by Kazuki Yamamoto on 2023/12/12.
//

import Foundation
import XCTest
@testable import SwishCore

final class PathTests: XCTestCase {
    func testSimple() throws {
        XCTAssertEqual(Path(string: "/path/to/dir").string, "/path/to/dir")
    }
}
