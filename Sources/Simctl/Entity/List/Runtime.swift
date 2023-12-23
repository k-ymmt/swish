//
//  Runtime.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation
import SwishCore

public extension SimulatorControl.List {
    @CustomCodingKeys
    struct Runtime: Decodable {
        public let bundlePath: Path
        @CustomCodingKey(name: "buildversion")
        public let buildVersion: String
        public let platform: String
        public let runtimeRoot: Path
        public let identifier: String
        public let version: String
        public let isInternal: Bool
        public let isAvailable: Bool
        public let name: String
    }
}
