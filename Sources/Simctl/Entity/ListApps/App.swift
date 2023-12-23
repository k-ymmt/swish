//
//  App.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/11.
//

import Foundation
import SwishCore

public extension SimulatorControl {
    @CustomCodingKeys
    struct App: Decodable {
        @CustomCodingKey(name: "ApplicationType")
        public let applicationType: String
        @CustomCodingKey(name: "Bundle")
        public let bundle: Path
        @CustomCodingKey(name: "CFBundleDisplayName")
        public let displayName: String
        @CustomCodingKey(name: "CFBundleExecutable")
        public let executable: String
        @CustomCodingKey(name: "CFBundleIdentifier")
        public let identifier: String
        @CustomCodingKey(name: "CFBundleName")
        public let name: String
        @CustomCodingKey(name: "CFBundleVersion")
        public let version: String
        @CustomCodingKey(name: "DataContainer")
        public let dataContainer: Path?
        @CustomCodingKey(name: "GroupContainers")
        public let groupContainers: [String: Path]
        @CustomCodingKey(name: "Path")
        public let path: Path
        @CustomCodingKey(name: "SBAppTags")
        public let appTags: [String]
    }
}
