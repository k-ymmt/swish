//
//  List.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation
import SwishCore

public extension SimulatorControl {
    @CustomCodingKeys
    struct List: Decodable {
        @CustomCodingKey(name: "devicetypes")
        public let deviceTypes: [DeviceType]
        public let runtimes: [Runtime]
        public let devices: [String: [Device]]
        public let pairs: [String: Pair]
    }
}
