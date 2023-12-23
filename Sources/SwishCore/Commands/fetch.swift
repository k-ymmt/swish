//
//  fetch.swift
//  
//
//  Created by Kazuki Yamamoto on 2023/12/10.
//

import Foundation

public enum FetchError {
    public struct InvalidURL: LocalizedError {
        public let urlString: String

        public var errorDescription: String {
            "Invalid URL: \(urlString)"
        }
    }

    public struct NotHTTPResponse: LocalizedError {
        public var errorDescription: String {
            "Not HTTP response"
        }
    }

    public struct UnexpectedHTTPStatusCode: LocalizedError {
        public let statusCode: Int

        public var errorDescription: String {
            "Unexpected http status code: \(statusCode)"
        }
    }

    public struct InvalidEncoding: LocalizedError {
        let data: Data

        public var errorDescription: String {
            "Response string is not UTF-8: \(data.map(String.init).joined(separator: " "))"
        }
    }
}

public func fetch(_ urlString: String, headers: [String: String] = [:], body: Data? = nil) async throws -> String {
    guard let url = URL(string: urlString) else {
        throw FetchError.InvalidURL(urlString: urlString)
    }
    return try await fetch(url, headers: headers, body: body)
}

public func fetch(_ url: URL, headers: [String: String] = [:], body: Data? = nil) async throws -> String {
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = headers
    request.httpBody = body
    let (result, response) = try await URLSession.shared.data(for: request)

    guard let response = response as? HTTPURLResponse else {
        throw FetchError.NotHTTPResponse()
    }

    guard (200..<300).contains(response.statusCode) else {
        throw FetchError.UnexpectedHTTPStatusCode(statusCode: response.statusCode)
    }

    guard let string = String(data: result, encoding: .utf8) else {
        throw FetchError.InvalidEncoding(data: result)
    }
    return string
}
