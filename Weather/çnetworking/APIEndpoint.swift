//
//  WeatherStatusWorker.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import Foundation

enum APIEndpoint {
    case getWeather(latitude: Double, longitude: Double)
    
    private var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "OpenWeatherBaseURL") as? String ?? ""
    }
    
    private var appID: String {
        return Bundle.main.object(forInfoDictionaryKey: "OpenWeatherAppID") as? String ?? ""
    }
    
    var urlString: String {
        switch self {
        case .getWeather(let latitude, let longitude):
            return "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(appID)"
        }
    }
    
    var url: URL? {
        return URL(string: urlString)
    }
}
