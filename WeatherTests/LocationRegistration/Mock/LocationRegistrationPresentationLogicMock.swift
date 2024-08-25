//
//  LocationRegistrationPresentationLogicMock.swift
//  WeatherTests
//
//  Created by Oscar Sierra Zuñiga on 24/08/24.
//

import XCTest
@testable import Weather

class LocationRegistrationPresentationLogicMock: LocationRegistrationPresentationLogic {

    var didSaveLocationSuccessfullyCalled = false
    var didFailToSaveLocationCalled = false
    var error: Error?

    func didSaveLocationSuccessfully() {
        didSaveLocationSuccessfullyCalled = true
    }

    func didFailToSaveLocation(error: Error) {
        didFailToSaveLocationCalled = true
        self.error = error
    }
}
