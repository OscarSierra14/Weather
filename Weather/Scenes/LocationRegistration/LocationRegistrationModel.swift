//
//  LocationRegistrationModel.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

struct Location {
    let id: String
    let cityName: String
    let latitude: Double
    let longitude: Double
    let registrationDate: Date
    let currentWeather: WeatherResponse
}
