//
//  WeatherStatusInteractor.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

protocol WeatherStatusBusinessLogic {
    func fetchWeatherForLocation()
    func fetchMyWeather()
}

protocol WeatherStatusDataStore {
    var savedWeather: [SavedLocation]? { get }
}

class WeatherStatusInteractor: WeatherStatusBusinessLogic, WeatherStatusDataStore {
    var presenter: WeatherStatusPresentationLogic? = nil
    var weatherService: WeatherServiceProtocol
    var localStorage: LocationStorageProtocol
    var locationService: LocationService
    var savedWeather: [SavedLocation]? = nil

    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        localStorage: LocationStorageProtocol = LocationStorage(),
        locationService: LocationService = LocationService()
    ) {
        self.weatherService = weatherService
        self.localStorage = localStorage
        self.locationService = locationService
        locationService.startLocationUpdates()
    }

    func fetchWeatherForLocation() {
        savedWeather = localStorage.fetchAllLocations()
        presenter?.reloadViewData()
    }

    func fetchMyWeather() {
        let coordinate = locationService.getCurrentCoordinates()
        guard let latitude = coordinate?.latitude,
              let longitude = coordinate?.longitude
        else {
            return
        }
        
        weatherService.fetchWeather(
            for: latitude,
            longitude: longitude) { [weak self] response in
                switch response {
                case .success(let weather):
                    self?.presenter?.showWeatherModal(with: weather)
                case .failure(let error):
                    self?.presenter?.failedFetchCurrentWeather(error: error.localizedDescription)
                }
            }
    }
}
