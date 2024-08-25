//
//  NetworkError.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import Foundation

struct APIErrorResponse: Decodable {
    let cod: String
    let message: String
}

enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case invalidData
    case decodingError(Error)
    case serverError(Int)
    case apiError(APIErrorResponse)
    
    var localizedDescription: String {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .requestFailed(let error):
            return "Request failed with error: \(error.localizedDescription)"
        case .invalidData:
            return "Received invalid data."
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let statusCode):
            return "Server returned an error with status code: \(statusCode)."
        case .apiError(let apiError):
            return "API error - Code: \(apiError.cod), Message: \(apiError.message)"
        }
    }
}
