//
//  Device.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation
import SwishCore

public extension SimulatorControl.List {
    struct Device: Decodable {
        public let availabilityError: String?
        @ISO8061Date
        public var lastBootedAt: Date?
        public let dataPath: Path
        public let dataPathSize: Int64
        public let logPath: Path
        public let logPathSize: Int64?
        public let udid: String
        public let isAvailable: Bool
        public let deviceTypeIdentifier: String
        public let state: State
        public let name: String
    }
}
