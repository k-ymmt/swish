//
//  Swish+Clean.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/15.
//

import Foundation
import ArgumentParser
import SwishCore

extension Swish {
    struct Clean: ParsableCommand {
        struct Error: LocalizedError {
            let message: String

            var errorDescription: String {
                "clean error: \(message)"
            }
        }
        @Argument
        var path: Path?

        @OptionGroup
        var options: Options

        func run() throws {
            Swish.commonAction(options: options)
            if let path {
                let outputPath = PathGenerator.makeProjectDirPath(filePath: path)
                guard outputPath.exists else {
                    throw Error(message: "\(path) not found")
                }

                echo("removing \(outputPath)...")
                try rm(at: outputPath)
                echo("clean cached \(outputPath.basenameWithoutExtension) project directory success!")
            } else if options.libPath.exists {
                echo("removing \(options.libPath.exists) ...")
                try rm(at: options.libPath)
                echo("removing \(options.binPath.exists) ...")
                try rm(at: options.binPath)
                echo("clean success!")
            }
        }
    }
}
