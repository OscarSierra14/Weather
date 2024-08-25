//
//  WeatherStatusModels.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

struct WeatherStatus {
    let locationID: UUID
    let temperature: Double
    let description: String
    let icon: String
}

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
    let id: Int
}

struct Weather: Codable {
    let information: String
    let icon: String
    
    var iconURL: String {
        return "https://openweathermap.org/img/wn/\(icon)@2x.png"
    }
    
    enum CodingKeys: String, CodingKey {
        case information = "description"
        case icon
    }
}

struct Main: Codable {
    let temp: Double
    
    func kelvinToCelsius() -> Double {
        return (temp) - 273.15
    }

    func formattedTemperature() -> String {
        let celsius = kelvinToCelsius()
        return String(format: "%.1f°C", celsius)
    }
}
