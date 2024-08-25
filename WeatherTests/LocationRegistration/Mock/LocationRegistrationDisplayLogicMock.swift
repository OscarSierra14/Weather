//
//  LocationRegistrationDisplayLogicMock.swift
//  WeatherTests
//
//  Created by Oscar Sierra Zuñiga on 24/08/24.
//

import XCTest
@testable import Weather

class LocationRegistrationDisplayLogicMock: LocationRegistrationDisplayLogic {

    var showLocationSuccessMessageCalled = false
    var showLocationFailureMessageCalled = false
    var successMessage: String?
    var error: Error?

    func showLocationSuccessMessage(message: String) {
        showLocationSuccessMessageCalled = true
        successMessage = message
    }

    func showLocationFailureMessage(error: Error) {
        showLocationFailureMessageCalled = true
        self.error = error
    }
}
