//
//  Swish+Edit.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/15.
//

import Foundation
import ArgumentParser
import SwishCore

extension Swish {
    struct Edit: AsyncParsableCommand {
        @Argument
        var filePath: Path
        @OptionGroup
        var options: Options

        func run() async throws {
            Swish.commonAction(options: options)
            try makeSourceFileIfNeeded(path: filePath)
            let projectDir = PathGenerator.makeProjectDirPath(filePath: filePath)
            if !projectDir.exists {
                try mkdir(at: projectDir)
            }
            let sourceDir = projectDir + "Sources"
            if sourceDir.exists {
                try rm(at: sourceDir)
            }
            try mkdir(at: sourceDir)
            let sourcePath = sourceDir + "main.swift"
            try ln(at: sourcePath, to: makeAbsolutePathIfNeeded(path: filePath, relativeTo: .current), linkType: .soft)
            let packageFile = projectDir + "Package.swift"
            if packageFile.exists {
                try rm(at: packageFile)
            }
            try packageContent(
                productName: filePath.basenameWithoutExtension,
                toolsVersion: try await getSwiftVersion() ?? ""
            ) > packageFile

            try await %"open \(packageFile)"
        }
    }
}

private extension Swish.Edit {
    func packageContent(productName: String, toolsVersion: String) -> String {
        """
        // swift-tools-version: \(toolsVersion)
        // The swift-tools-version declares the minimum version of Swift required to build this package.

        import PackageDescription

        let package = Package(
            name: "\(productName)",
            platforms: [.macOS(.v13)],
            dependencies: [
                .package(path: "\(PathGenerator.swishProjectDir())")
            ],
            targets: [
                .executableTarget(
                    name: "\(productName)",
                    dependencies: [
                        .product(name: "SwishCore", package: "swish"),
                    ]
                )
            ]
        )
        """
    }

    func makeSourceFileIfNeeded(path: Path) throws {
        guard !path.exists else {
            return
        }

        let contents = """
            #!\(options.binPath)
            import SwishCore

            """
        try makeFile(at: path, contents: contents, attributes: [.posixPermissions: 0o764])
    }

    func getSwiftVersion() async throws -> String? {
        let result = try await %"swift -version"
        let regex = try Regex("Apple Swift version (?<version>.*?) ")
        let version = result.firstMatch(of: regex)?["version"]?.value as? Substring
        return version.map(String.init)
    }
}
