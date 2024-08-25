//
//  LocationRegistrationViewController.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

protocol LocationRegistrationDisplayLogic: AnyObject {
    func showLocationSuccessMessage(message: String)
    func showLocationFailureMessage(error: Error)
}

class LocationRegistrationViewController: BaseViewController, LocationRegistrationDisplayLogic {
    
    var interactor: (LocationRegistrationBusinessLogic & LocationRegistrationDataStore)?
    var router: (NSObjectProtocol & LocationRegistrationRoutingLogic & LocationRegistrationDataPassing)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = LocationRegistrationInteractor()
        let presenter = LocationRegistrationPresenter()
        let router = LocationRegistrationRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        interactor?.startWeatherMonitoring()
    }

    internal let cityNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City Name"
        textField.borderStyle = .roundedRect
        textField.text = "Tolù"
        return textField
    }()
    
    internal let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Latitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.text = "9.533"
        return textField
    }()
    
    internal let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Longitude"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.text = "-75.583"
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Location", for: .normal)

        return button
    }()
    
    private func setupUI() {
        view.backgroundColor = .white

        saveButton.addTarget(
            self,
            action: #selector(saveLocationButtonTapped),
            for: .touchUpInside
        )

        let stackView = UIStackView(arrangedSubviews: [cityNameTextField, latitudeTextField, longitudeTextField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16

        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    @objc func saveLocationButtonTapped() {
        guard
            let cityName = cityNameTextField.text, !cityName.isEmpty,
            let latitudeText = latitudeTextField.text,
            let longitudeText = longitudeTextField.text
        else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid input"])
            showLocationFailureMessage(error: error)
            return
        }
        
        interactor?.fetchLocationWeather(cityName: cityName, lat: latitudeText, long: longitudeText)
    }

    func showLocationSuccessMessage(message: String) {
        showToast(message: message, state: .info)
    }
    
    func showLocationFailureMessage(error: Error) {
        showToast(message: error.localizedDescription, state: .critical)
    }
}
