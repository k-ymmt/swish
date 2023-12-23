//
//  ISO8061Date.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation

@propertyWrapper
public struct ISO8061Date: Decodable {
    private static let formatter: ISO8601DateFormatter = .init()
    public let wrappedValue: Date?

    public init(wrappedValue: Date?) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)
        wrappedValue = Self.formatter.date(from: dateString)
    }
}

public extension KeyedDecodingContainer {
    func decode(_ type: ISO8061Date.Type, forKey key: K) throws -> ISO8061Date {
        if let value = try decodeIfPresent(type, forKey: key) {
            return value
        }

        return ISO8061Date(wrappedValue: nil)
    }
}
