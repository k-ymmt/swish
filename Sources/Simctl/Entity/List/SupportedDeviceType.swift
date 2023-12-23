//
//  SupportedDeviceType.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation
import SwishCore

public extension SimulatorControl.List.Runtime {
    struct SupportedDeviceType: Decodable {
        public let bundlePath: Path
        public let name: String
        public let identifier: String
        public let productFamily: SimulatorControl.List.ProductFamily
    }
}
