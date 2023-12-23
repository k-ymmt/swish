//
//  DeviceType.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation
import SwishCore

public extension SimulatorControl.List {
    struct DeviceType: Decodable {
        public let productFamily: ProductFamily
        public let bundlePath: Path
        public let maxRuntimeVersion: Int
        public let maxRuntimeVersionString: String
        public let identifier: String
        public let modelIdentifier: String
        public let minRuntimeVersionString: String
        public let minRuntimeVersion: Int
        public let name: String
    }
}
