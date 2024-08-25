//
//  File.swift
//  WeatherTests
//
//  Created by Oscar Sierra Zuñiga on 24/08/24.
//

import XCTest
@testable import Weather

class LocationStorageProtocolMock: LocationStorageProtocol {
    var saveCalled = false
    var shouldThrowError = false
    var fetchLocationCalled = false
    var savedLocation: Location?
    var fetchAllLocationsCalled = false
    var updateCalled = false

    func save(location: Location) throws {
        saveCalled = true
        savedLocation = location
        if shouldThrowError {
            throw NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Save error"])
        }
    }

    func fetchLocation(byCityIdentifier cityIdentifier: Int64) -> SavedLocation? {
        fetchLocationCalled = true
        return nil
    }

    func fetchAllLocations() -> [SavedLocation] {
        fetchAllLocationsCalled = true
        return []
    }

    func update(location: Location) throws {
        updateCalled = true
    }
}

