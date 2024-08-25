//
//  NetworkingRequest.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import Foundation

struct NetworkRequest {
    let endpoint: APIEndpoint
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?

    init(endpoint: APIEndpoint, method: HTTPMethod = .get, headers: [String: String]? = nil, body: Data? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.headers = headers
        self.body = body
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
