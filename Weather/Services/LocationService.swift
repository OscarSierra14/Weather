//
//  LocationService.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import CoreLocation
import UIKit

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var onLocationUpdate: ((CLLocation) -> Void)?
    private var currentLocation: CLLocation?
    weak var presentingViewController: UIViewController?

    func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true // Permitir actualizaciones en background
        locationManager.pausesLocationUpdatesAutomatically = false

        checkLocationAuthorizationStatus()
    }

    private func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            showPermissionDeniedAlert()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        onLocationUpdate?(location)
    }

    func getCurrentCoordinates() -> CLLocationCoordinate2D? {
        checkLocationAuthorizationStatus()
        return currentLocation?.coordinate
    }

    private func showPermissionDeniedAlert() {
        guard let viewController = presentingViewController else { return }
        
        let alertController = UIAlertController(
            title: "Permiso de Ubicación Requerido",
            message: "La aplicación necesita acceso a tu ubicación para mostrar el clima local. Por favor, habilita los permisos en Configuración.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Ir a Configuración", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
