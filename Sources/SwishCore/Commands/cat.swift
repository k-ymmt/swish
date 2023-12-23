//
//  cat.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/13.
//

import Foundation

public func cat(at path: Path) throws -> String {
    let data = try Data(contentsOf: path.url)
    guard let string = String(data: data, encoding: .utf8) else {
        throw PathError.InvalidEncoding.data(data)
    }

    return string
}
