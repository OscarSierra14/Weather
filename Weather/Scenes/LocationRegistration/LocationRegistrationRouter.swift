//
//  LocationRegistrationRouter.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

@objc protocol LocationRegistrationRoutingLogic {
}

protocol LocationRegistrationDataPassing {
    var dataStore: LocationRegistrationDataStore? { get }
}

class LocationRegistrationRouter: NSObject, LocationRegistrationRoutingLogic, LocationRegistrationDataPassing {

    weak var viewController: LocationRegistrationViewController?
    var dataStore: LocationRegistrationDataStore?
}
