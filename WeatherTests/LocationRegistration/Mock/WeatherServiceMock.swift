//
//  File.swift
//  WeatherTests
//
//  Created by Oscar Sierra Zuñiga on 24/08/24.
//

import XCTest
@testable import Weather

class WeatherServiceMock: WeatherServiceProtocol {
    var weatherResponseResult: Result<WeatherResponse, NetworkError>?

    
    func fetchWeather(for latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, NetworkError>) -> Void) {
        if let result = weatherResponseResult {
            completion(result)
        }
    }
}

