//
//  LocationRegistrationInteractor.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

protocol LocationRegistrationBusinessLogic {
    func fetchLocationWeather(cityName: String, lat: String, long: String)
    func startWeatherMonitoring()
}

protocol LocationRegistrationDataStore {
}

class LocationRegistrationInteractor: LocationRegistrationBusinessLogic, LocationRegistrationDataStore {
    var presenter: LocationRegistrationPresentationLogic?
    var localStorage: LocationStorageProtocol!
    var weatherService: WeatherServiceProtocol = WeatherService()
    private let weatherMonitoringService = WeatherMonitoringService()

    init(presenter: LocationRegistrationPresentationLogic? = nil, localStorage: LocationStorageProtocol = LocationStorage()) {
        self.presenter = presenter
        self.localStorage = localStorage
    }

    func fetchLocationWeather(cityName: String, lat: String, long: String) {
        guard let latitude = Double(lat),
              let longitude = Double(long)
        else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid input"])
            presenter?.didFailToSaveLocation(error: error)
            return
        }

        weatherService.fetchWeather(for: latitude, longitude: longitude) { [weak self] response in
            switch response {
            case .success(let weather):
                self?.saveLocation(name: cityName, lat: latitude, long: longitude, weatherResponse: weather)
            case .failure(let error):
                if case .apiError(let apiError) = error {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: apiError.message.capitalized])
                    self?.presenter?.didFailToSaveLocation(error: error)
                    return
                }
                
                self?.presenter?.didFailToSaveLocation(error: error)
            }
        }
    }

    func saveLocation(name: String, lat: Double, long: Double, weatherResponse: WeatherResponse) {
        let location = Location(
            id: UUID().uuidString,
            cityName: name,
            latitude: lat,
            longitude: long,
            registrationDate: Date(),
            currentWeather: weatherResponse
        )

        do {
            try localStorage.save(location: location)
            presenter?.didSaveLocationSuccessfully()
        } catch let error as NSError {
            presenter?.didFailToSaveLocation(error: error)
        }
    }

    func startWeatherMonitoring() {
        Timer.scheduledTimer(withTimeInterval: 100, repeats: true) { [weak self] _ in
            self?.weatherMonitoringService.monitorWeatherChanges()
        }
    }
}
