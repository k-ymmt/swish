//
//  ProductFamily.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation

public extension SimulatorControl.List {
    enum ProductFamily: Decodable {
        case iPhone
        case iPad
        case appleWatch
        case appleTV
        case unknown(String)

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let family = try container.decode(String.self)

            switch family {
            case "iPhone":
                self = .iPhone
            case "iPad":
                self = .iPad
            case "Apple Watch":
                self = .appleWatch
            case "Apple TV":
                self = .appleTV
            default:
                self = .unknown(family)
            }
        }
    }
}

extension SimulatorControl.List.ProductFamily: CustomStringConvertible {
    public var description: String {
        switch self {
        case .iPhone:
            "iPhone"
        case .iPad:
            "iPad"
        case .appleWatch:
            "Apple Watch"
        case .appleTV:
            "Apple TV"
        case .unknown(let string):
            string
        }
    }
}
