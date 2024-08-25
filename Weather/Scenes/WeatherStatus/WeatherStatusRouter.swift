//
//  WeatherStatusRouter.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

@objc protocol WeatherStatusRoutingLogic {
}

protocol WeatherStatusDataPassing {
    var dataStore: WeatherStatusDataStore? { get }
}

class WeatherStatusRouter: NSObject, WeatherStatusRoutingLogic, WeatherStatusDataPassing {
    weak var viewController: WeatherStatusViewController?
    var dataStore: WeatherStatusDataStore?
}
