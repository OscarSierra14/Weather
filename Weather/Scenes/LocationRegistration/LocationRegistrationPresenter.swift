//
//  LocationRegistrationPresenter.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

protocol LocationRegistrationPresentationLogic {
    func didSaveLocationSuccessfully()
    func didFailToSaveLocation(error: Error)
}

class LocationRegistrationPresenter: LocationRegistrationPresentationLogic {
    
    weak var viewController: LocationRegistrationDisplayLogic?

    func didSaveLocationSuccessfully() {
        viewController?.showLocationSuccessMessage(message: "Registro Satisfactorio")
    }
    
    func didFailToSaveLocation(error: Error) {
        viewController?.showLocationFailureMessage(error: error)
    }
}
