//
//  LocationRegistrationIntegrationTests.swift
//  WeatherTests
//
//  Created by Oscar Sierra Zuñiga on 24/08/24.
//

import XCTest
@testable import Weather

class LocationRegistrationIntegrationTests: XCTestCase {

    var viewController: LocationRegistrationViewController!
    var interactor: LocationRegistrationInteractor!
    var presenter: LocationRegistrationPresenter!
    var router: LocationRegistrationRouter!
    var localStorageMock: LocationStorageProtocolMock!
    var weatherServiceMock: WeatherServiceMock!

    override func setUp() {
        super.setUp()
        
        localStorageMock = LocationStorageProtocolMock()
        weatherServiceMock = WeatherServiceMock()

        viewController = LocationRegistrationViewController()
        presenter = LocationRegistrationPresenter()
        interactor = LocationRegistrationInteractor(presenter: presenter, localStorage: localStorageMock)
        router = LocationRegistrationRouter()

        viewController.interactor = interactor
        viewController.router = router
        interactor.weatherService = weatherServiceMock
        presenter.viewController = viewController
        router.dataStore = interactor
    }

    override func tearDown() {
        viewController = nil
        interactor = nil
        presenter = nil
        router = nil
        localStorageMock = nil
        weatherServiceMock = nil
        super.tearDown()
    }

    func testSuccessfulLocationSaveIntegration() {
        // Given
        let cityName = "Tolù"
        let latitude = "9.533"
        let longitude = "-75.583"
        let expectedWeather = WeatherResponse(weather: [Weather.init(information: "This is information", icon: "1d2")], main: Main(temp: 1.0), name: "Tolù", id: 1234)
        weatherServiceMock.weatherResponseResult = .success(expectedWeather)
        
        // When
        viewController.cityNameTextField.text = cityName
        viewController.latitudeTextField.text = latitude
        viewController.longitudeTextField.text = longitude
        viewController.saveLocationButtonTapped()
        
        // Then
        XCTAssertTrue(localStorageMock.saveCalled, "Location should be saved to local storage")
        XCTAssertEqual(localStorageMock.savedLocation?.cityName, cityName, "City name should match")
        XCTAssertEqual(localStorageMock.savedLocation?.latitude, 9.533, "Latitude should match")
        XCTAssertEqual(localStorageMock.savedLocation?.longitude, -75.583, "Longitude should match")
    }

    func testFailedLocationSaveDueToInvalidInputIntegration() {
        // Given
        viewController.cityNameTextField.text = "Tolù"
        viewController.latitudeTextField.text = "invalid_latitude"
        viewController.longitudeTextField.text = "-75.583"
        
        // When
        viewController.saveLocationButtonTapped()
        
        // Then
        XCTAssertFalse(localStorageMock.saveCalled, "Location should not be saved to local storage")
    }

    func testFailedLocationSaveDueToApiErrorIntegration() {
        // Given
        let cityName = "Tolù"
        let latitude = "9.533"
        let longitude = "-75.583"
        let apiError = APIErrorResponse(cod: "1223", message: "Api Error")
        weatherServiceMock.weatherResponseResult = .failure(.apiError(apiError))
        
        // When
        viewController.cityNameTextField.text = cityName
        viewController.latitudeTextField.text = latitude
        viewController.longitudeTextField.text = longitude
        viewController.saveLocationButtonTapped()
        
        // Then
        XCTAssertFalse(localStorageMock.saveCalled, "Location should not be saved to local storage")
    }
}
