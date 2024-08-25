//
//  WeatherStatusPresenter.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

protocol WeatherStatusPresentationLogic {
    func reloadViewData()
    func showWeatherModal(with response: WeatherResponse)
    func failedFetchCurrentWeather(error: String)
}

class WeatherStatusPresenter: WeatherStatusPresentationLogic {
    
    weak var viewController: WeatherStatusDisplayLogic?
    
    func reloadViewData() {
        viewController?.reloadData()
    }

    func showWeatherModal(with response: WeatherResponse) {
        viewController?.showWeatherModal(with: response)
    }

    func failedFetchCurrentWeather(error: String) {
        viewController?.failedFetchCurrentWeather(error: error)
    }
}
