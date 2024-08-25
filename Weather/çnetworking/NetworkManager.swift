//
//  NetworkManager.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import Foundation

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func performRequest<T: Decodable>(
        _ request: NetworkRequest,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        guard let url = request.endpoint.url else {
            completion(.failure(.badURL))
            return
        }

        var urlRequest = URLRequest(url: url)
        configureRequest(&urlRequest, with: request)

        session.dataTask(with: urlRequest) { data, response, error in
            let networkResponse = NetworkResponse<T>(data: data, response: response, error: error)
            DispatchQueue.main.async {
                completion(networkResponse.result)
            }
        }.resume()
    }

    private func configureRequest(_ urlRequest: inout URLRequest, with request: NetworkRequest) {
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpBody = request.body
    }
}
