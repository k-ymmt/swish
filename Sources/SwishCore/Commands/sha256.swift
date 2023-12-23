//
//  sha256.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/24.
//

import Foundation
import Crypto

public func sha256(from path: Path) throws -> Data {
    let data = try Data(contentsOf: path)

    return Data(SHA256.hash(data: data))
}

public func sha256(from string: String, using encoding: String.Encoding = .utf8) throws -> Data? {
    try string.data(using: encoding).map(sha256(from:))
}

public func sha256(from data: Data) throws -> Data {
    Data(SHA256.hash(data: data))
}
