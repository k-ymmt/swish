//
//  Swish+Run.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/15.
//

import Foundation
import SwishCore
import ArgumentParser

extension Swish {
    struct Run: AsyncParsableCommand {
        @Argument
        var path: Path

        @Option(name: .shortAndLong)
        var configuration: Configuration = .release

        @OptionGroup
        var options: Options

        func run() async throws {
            Swish.commonAction(options: options)
            let outputDir = PathGenerator.makeProjectDirPath(filePath: path) + ".bin/"
            if !outputDir.exists {
                try mkdir(at: outputDir)
            }
            let outputPath = outputDir + path.basenameWithoutExtension

            if isModified(path: path) {
                try await build(outputPath: outputPath)
                saveHash(path: path)
            } else {
                debug("Not modified file: \(path.basename).")
                debug("Build skip.")
            }

            env[EnvironmentVariable.SwishKeys.executeFilePath] = String(describing: makeAbsolutePathIfNeeded(path: path, relativeTo: .current))
            env[EnvironmentVariable.SwishKeys.configuration] = String(describing: configuration)

            for try await output in sh(String(describing: outputPath)).stream {
                echo(output, terminator: "")
            }
        }
    }
}

extension Swish.Run {
    enum Configuration: String, CustomStringConvertible, ExpressibleByArgument {
        case debug
        case release

        init?(argument: String) {
            self.init(rawValue: argument)
        }

        var description: String {
            rawValue
        }
    }
}

private extension Swish.Run {
    func build(outputPath: Path) async throws {
        let command = buildCommand(
            path: path,
            output: outputPath,
            configuration: configuration,
            options: options
        )

        let (output, _) = sh(command)
        for try await line in output {
            echo(line.error, terminator: "")
        }
    }
}

private func buildCommand(path: Path, output: Path, configuration: Swish.Run.Configuration, options: Swish.Options) -> String {
    let optimize = switch configuration {
    case .debug:
        "-Onone"
    case .release:
        "-O"
    }
    let define = switch configuration {
    case .debug:
        "DEBUG"
    case .release:
        "RELEASE"
    }
    let libPath = String(describing: options.libPath)
    return [
        "swiftc",
        "-emit-executable",
        String(describing: path),
        optimize,
        "-D",
        define,
        "-L",
        libPath,
        "-lSwishCore",
        "-I",
        libPath,
        "-Xlinker",
        "-rpath",
        "-Xlinker",
        libPath,
        "-o",
        String(describing: output),
    ].joined(separator: " ")
}

private func makeOptions(from configuration: Swish.Run.Configuration) -> String {
    switch configuration {
    case .debug:
        "-Onone -D DEBUG"
    case .release:
        "-O -D RELEASE"
    }
}

private func isModified(path: Path) -> Bool {
    let cacheSwiftFilePath = PathGenerator.makeCacheSwiftFilePath(filePath: path)

    guard cacheSwiftFilePath.exists else {
        debug("Cache not found")
        return true
    }
    do {
        let old = try Data(contentsOf: cacheSwiftFilePath)
        let current = try sha256(from: path)
        return old != current
    } catch {
        Logger.error(error)
        return true
    }
}

private func saveHash(path: Path) {
    guard path.exists else {
        debug("Path not found \(path)")
        return
    }
    do {
        let cacheSwiftFilePath = PathGenerator.makeCacheSwiftFilePath(filePath: path)
        let cacheSwiftFileDir = cacheSwiftFilePath.dirpath
        if !cacheSwiftFileDir.exists {
            try mkdir(at: cacheSwiftFileDir)
        }
        try sha256(from: path) > cacheSwiftFilePath
    } catch {
        Logger.error(error)
    }
}
