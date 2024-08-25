//
//  LocationRegistrationPresenterTests.swift
//  WeatherTests
//
//  Created by Oscar Sierra Zuñiga on 24/08/24.
//

import XCTest
@testable import Weather

class LocationRegistrationPresenterTests: XCTestCase {

    var presenter: LocationRegistrationPresenter!
    var viewControllerMock: LocationRegistrationDisplayLogicMock!

    override func setUp() {
        super.setUp()
        presenter = LocationRegistrationPresenter()
        viewControllerMock = LocationRegistrationDisplayLogicMock()
        presenter.viewController = viewControllerMock
    }

    override func tearDown() {
        presenter = nil
        viewControllerMock = nil
        super.tearDown()
    }

    func testDidSaveLocationSuccessfully() {
        // When
        presenter.didSaveLocationSuccessfully()

        // Then
        XCTAssertTrue(viewControllerMock.showLocationSuccessMessageCalled)
        XCTAssertEqual(viewControllerMock.successMessage, "Registro Satisfactorio")
    }

    func testDidFailToSaveLocation() {
        // Given
        let expectedError = NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test Error"])

        // When
        presenter.didFailToSaveLocation(error: expectedError)

        // Then
        XCTAssertTrue(viewControllerMock.showLocationFailureMessageCalled)
        XCTAssertEqual(viewControllerMock.error?.localizedDescription, expectedError.localizedDescription)
    }
}
