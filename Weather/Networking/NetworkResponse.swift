//
//  NetworkResponse.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import Foundation

struct NetworkResponse<T: Decodable> {
    let result: Result<T, NetworkError>

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.result = Self.processResponse(data: data, response: response, error: error)
    }

    private static func processResponse(data: Data?, response: URLResponse?, error: Error?) -> Result<T, NetworkError> {
        if let error = error {
            return .failure(.requestFailed(error))
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidData)
        }

        guard let data = data else {
            return .failure(.invalidData)
        }

        if httpResponse.statusCode == 200 {
            return decodeData(data)
        } else {
            return decodeAPIError(data) ?? .failure(.serverError(httpResponse.statusCode))
        }
    }

    private static func decodeData(_ data: Data) -> Result<T, NetworkError> {
        return Result {
            try JSONDecoder().decode(T.self, from: data)
        }.mapError {
            .decodingError($0)
        }
    }

    private static func decodeAPIError(_ data: Data) -> Result<T, NetworkError>? {
        if let apiError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
            return .failure(.apiError(apiError))
        }
        return nil
    }
}
