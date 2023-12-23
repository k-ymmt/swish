//
//  echo.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/15.
//

import Foundation

public func echo(_ message: Any?, terminator: String = "\n") {
    guard let message else {
        return
    }
    let string = String(describing: message)
    echo(string, terminator: terminator)
}

public func echo(_ message: String, terminator: String = "\n") {
    fputs(message + terminator, stdout)
    fflush(stdout)
}
