// swift-tools-version: 5.9.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "swish",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "swish", targets: ["swish"]),
        .library(
            name: "SwishCore",
            type: .dynamic,
            targets: ["SwishCore", "Simctl", "macOSSupport"]
        ),
    ],
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
        .package(url: "https://github.com/k-ymmt/Crayon.git", .upToNextMajor(from: "1.2.1")),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "swish",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SwishCore"
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals"),
            ]
        ),
        .macro(
            name: "SwishCoreMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "SwishCoreMacrosTests",
            dependencies: [
                "SwishCoreMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        .target(
            name: "SwishCore",
            dependencies: [
                "SwishCoreMacros",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Crypto", package: "swift-crypto"),
                "Crayon",
            ]
        ),
        .testTarget(
            name: "SwishCoreTests",
            dependencies: ["SwishCore"]
        ),
        .target(
            name: "Simctl",
            dependencies: ["SwishCore"]
        ),
        .target(
            name: "macOSSupport",
            dependencies: ["SwishCore"]
        ),
    ]
)
