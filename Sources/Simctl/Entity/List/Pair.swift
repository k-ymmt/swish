//
//  Pair.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation

public extension SimulatorControl.List {
    struct Pair: Decodable {
        public struct Device: Decodable {
            public let name: String
            public let udid: String
            public let state: State
        }

        public let watch: Device
        public let phone: Device
        public let state: State
    }
}
