//
//  ApsPayload.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/12.
//

import Foundation
import SwishCore

public struct ApsPayload: Codable {
    public struct Aps: Codable {
        @CustomCodingKeys
        public struct Alert: Codable {
            public let title: String
            public let subtitle: String?
            public let body: String?
            @CustomCodingKey(name: "launch-image")
            public let launchImage: String?

            public init(
                title: String,
                subtitle: String? = nil,
                body: String? = nil,
                launchImage: String? = nil
            ) {
                self.title = title
                self.subtitle = subtitle
                self.body = body
                self.launchImage = launchImage
            }
        }
        public let alert: Alert
        public let sound: Sound?
        public let badge: Int
        public let category: String?

        public init(alert: Alert, sound: Sound? = nil, badge: Int = 0, category: String? = nil) {
            self.alert = alert
            self.sound = sound
            self.badge = badge
            self.category = category
        }

        public struct Sound: Codable {
            public let critical: Int?
            public let name: String
            public let volume: Int?

            public init(critical: Int?, name: String, volume: Int?) {
                self.critical = critical
                self.name = name
                self.volume = volume
            }

            public init(critical: Bool = false, name: String = "default", isSilent: Bool = false) {
                self.critical = critical ? 1 : 0
                self.name = name
                self.volume = isSilent ? 0 : 1
            }
        }
    }

    enum CodingKeys: String, CodingKey {
        case aps, gameID
        case simulatorTargetBundle = "Simulator Target Bundle"
    }

    public let simulatorTargetBundle: String?
    public let aps: Aps
    public let gameID: String?

    public init(simulatorTargetBundle: String? = nil, aps: Aps, gameID: String? = nil) {
        self.simulatorTargetBundle = simulatorTargetBundle
        self.aps = aps
        self.gameID = gameID
    }
}

extension ApsPayload.Aps.Alert: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .init(title: value)
    }
}

extension ApsPayload.Aps.Sound: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self = .init(critical: nil, name: value, volume: nil)
    }
}
