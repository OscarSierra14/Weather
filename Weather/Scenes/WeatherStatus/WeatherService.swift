//
//  WeatherService.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import Foundation

protocol WeatherServiceProtocol: AnyObject {
    func fetchWeather(for latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void)
}

class WeatherService: WeatherServiceProtocol {
    func fetchWeather(for latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        let request = NetworkRequest(endpoint: .getWeather(latitude: latitude, longitude: longitude), method: .get)
        
        NetworkManager.shared.performRequest(request, decodingType: WeatherResponse.self) { response in
            switch response {
            case .success(let weatherResponse):
                completion(.success(weatherResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
