//
//  State.swift
//
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation

public extension SimulatorControl.List {
    enum State: String, Decodable {
        case shutdown = "Shutdown"
        case booted = "Booted"
        case unavailable = "(unavailable)"
    }
}
