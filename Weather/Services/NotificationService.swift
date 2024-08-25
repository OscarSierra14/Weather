//
//  NotificationService.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import CoreData
import UserNotifications

class WeatherMonitoringService {
    private let weatherService: WeatherServiceProtocol = WeatherService()
    private let localStorage: LocationStorageProtocol = LocationStorage()

    func monitorWeatherChanges() {
        let savedLocations = localStorage.fetchAllLocations()

        for location in savedLocations {
            weatherService.fetchWeather(for: location.latitude ?? 0.0, longitude: location.longitude ?? 0.0) { [weak self] response in
                guard let self = self else { return }

                switch response {
                case .success(let newWeather):
                    if self.hasSignificantChange(oldWeather: location, newWeather: newWeather) {
                        self.sendWeatherChangeNotification(for: location, newWeather: newWeather)
                        self.updateStoredWeather(location: location, newWeather: newWeather)
                    }
                default:
                    break
                }
                
            }
        }
    }

    private func hasSignificantChange(oldWeather: SavedLocation, newWeather: WeatherResponse) -> Bool {
        return oldWeather.information != newWeather.weather.first?.information
    }

    private func sendWeatherChangeNotification(for location: SavedLocation, newWeather: WeatherResponse) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Weather Alert"
        notificationContent.body = "Weather changed to \(newWeather.weather.first?.information ?? "") in \(location.savedName ?? "")"
        notificationContent.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }

    private func updateStoredWeather(location: SavedLocation, newWeather: WeatherResponse) {
        guard let id = location.id,
              let savedName = location.savedName,
              let latitude = location.latitude,
              let longitude = location.longitude,
              let registrationDate = location.registrationDate
        else {
            return
        }

        do {
            try localStorage.update(
                location: .init(
                    id: id,
                    cityName: savedName,
                    latitude: latitude,
                    longitude: longitude,
                    registrationDate: registrationDate,
                    currentWeather: newWeather
                )
            )
        } catch {
            debugPrint("Error Updating data")
        }

        NotificationCenter.default.post(name: .updatedLocation, object: nil)
    }
}

