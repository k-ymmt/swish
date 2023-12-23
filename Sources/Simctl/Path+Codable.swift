//
//  Path+Codable.swift
//
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation
import SwishCore

extension Path: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        self.init(string: string)
    }
}

extension Path: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}
