//
//  LocationRegistrationInteractorTests.swift
//  WeatherTests
//
//  Created by Oscar Sierra Zuñiga on 24/08/24.
//

import XCTest
@testable import Weather

class LocationRegistrationInteractorTests: XCTestCase {

    var interactor: LocationRegistrationInteractor!
    var presenterMock: LocationRegistrationPresentationLogicMock!
    var localStorageMock: LocationStorageProtocolMock!
    var weatherServiceMock: WeatherServiceMock!

    override func setUp() {
        super.setUp()
        presenterMock = LocationRegistrationPresentationLogicMock()
        localStorageMock = LocationStorageProtocolMock()
        weatherServiceMock = WeatherServiceMock()
        interactor = LocationRegistrationInteractor(presenter: presenterMock, localStorage: localStorageMock)
        interactor.weatherService = weatherServiceMock
    }

    override func tearDown() {
        interactor = nil
        presenterMock = nil
        localStorageMock = nil
        weatherServiceMock = nil
        super.tearDown()
    }

    func testFetchLocationWeather_Success() {
        // Given
        let cityName = "Tolù"
        let lat = "9.533"
        let long = "-75.583"
        let expectedWeather = WeatherResponse(weather: [Weather.init(information: "This is information", icon: "1d2")], main: Main(temp: 1.0), name: "Tolù", id: 1234)

        weatherServiceMock.weatherResponseResult = .success(expectedWeather)

        // When
        interactor.fetchLocationWeather(cityName: cityName, lat: lat, long: long)

        // Then
        XCTAssertTrue(localStorageMock.saveCalled)
        XCTAssertTrue(presenterMock.didSaveLocationSuccessfullyCalled)
    }

    func testFetchLocationWeather_Failure_InvalidInput() {
        // Given
        let cityName = "Tolù"
        let lat = "invalid_latitude"
        let long = "-75.583"

        // When
        interactor.fetchLocationWeather(cityName: cityName, lat: lat, long: long)

        // Then
        XCTAssertFalse(localStorageMock.saveCalled)
        XCTAssertTrue(presenterMock.didFailToSaveLocationCalled)
        XCTAssertEqual((presenterMock.error as NSError?)?.localizedDescription, "Invalid input")
    }

    func testFetchLocationWeather_Failure_ApiError() {
        // Given
        let cityName = "Tolù"
        let lat = "9.533"
        let long = "-75.583"
        let apiError = APIErrorResponse(cod: "1223", message: "Api Error")

        weatherServiceMock.weatherResponseResult = .failure(.apiError(apiError))

        // When
        interactor.fetchLocationWeather(cityName: cityName, lat: lat, long: long)

        // Then
        XCTAssertFalse(localStorageMock.saveCalled)
        XCTAssertTrue(presenterMock.didFailToSaveLocationCalled)
    }

    func testSaveLocation_Success() {
        // Given
        let location = Location(id: "123", cityName: "cityName", latitude: 123.0, longitude: 1234.0, registrationDate: Date(), currentWeather: WeatherResponse(weather: [Weather.init(information: "This is information", icon: "1d2")], main: Main(temp: 0.1), name: "name", id: 134))

        // When
        interactor.saveLocation(name: location.cityName, lat: location.latitude, long: location.longitude, weatherResponse: location.currentWeather)

        // Then
        XCTAssertTrue(localStorageMock.saveCalled)
        XCTAssertTrue(presenterMock.didSaveLocationSuccessfullyCalled)
    }

    func testSaveLocation_Failure() {
        // Given
        let location = Location(id: "123", cityName: "cityName", latitude: 123.0, longitude: 1234.0, registrationDate: Date(), currentWeather: WeatherResponse(weather: [Weather.init(information: "This is information", icon: "1d2")], main: Main(temp: 0.1), name: "name", id: 134))
        localStorageMock.shouldThrowError = true

        // When
        interactor.saveLocation(name: location.cityName, lat: location.latitude, long: location.longitude, weatherResponse: location.currentWeather)

        // Then
        XCTAssertTrue(localStorageMock.saveCalled)
        XCTAssertTrue(presenterMock.didFailToSaveLocationCalled)
    }
}
