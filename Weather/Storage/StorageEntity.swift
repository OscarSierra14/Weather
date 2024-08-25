//
//  StorageEntity.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 23/08/24.
//

import Foundation

public struct SavedLocation {
    let id: String?
    let name: String?
    let savedName: String?
    let latitude: Double?
    let longitude: Double?
    let registrationDate: Date?
    let icon: String?
    let temperature: Double?
    let information: String?

    func kelvinToCelsius() -> Double {
        return (temperature ?? 0.0) - 273.15
    }

    func formattedTemperature() -> String {
        let celsius = kelvinToCelsius()
        return String(format: "%.1f°C", celsius)
    }
}
