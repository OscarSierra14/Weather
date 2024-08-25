//
//  WeatherStatusViewController.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

protocol WeatherStatusDisplayLogic: AnyObject {
    func reloadData()
    func showWeatherModal(with response: WeatherResponse)
    func failedFetchCurrentWeather(error: String)
}

class WeatherStatusViewController: BaseViewController, WeatherStatusDisplayLogic, UITableViewDelegate, UITableViewDataSource {
    var interactor: (WeatherStatusBusinessLogic & WeatherStatusDataStore)?
    var router: (NSObjectProtocol & WeatherStatusRoutingLogic & WeatherStatusDataPassing)?

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
        let interactor = WeatherStatusInteractor()
        let presenter = WeatherStatusPresenter()
        let router = WeatherStatusRouter()
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
        setupNavigationBarButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotificationObserver()
        interactor?.fetchWeatherForLocation()
    }

    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateData),
            name: .updatedLocation, object: nil)
    }

    @objc private func updateData() {
        interactor?.fetchWeatherForLocation()
    }

    private func setupNavigationBarButton() {
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "cloud.sun"), style: .plain, target: self, action: #selector(showWeatherInfo))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func showWeatherInfo() {
        interactor?.fetchMyWeather()
    }

    private func setupUI() {
        title = "Saved Locations"
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func reloadData() {
        self.tableView.reloadData()
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.viewId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.savedWeather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.viewId, for: indexPath) as! WeatherTableViewCell

        guard let data = interactor?.savedWeather?[indexPath.row]
        else {
            return UITableViewCell(frame: .zero)
        }

        cell.setupCell(with: data)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = interactor?.savedWeather?[indexPath.row]
        else {
            return
        }

        let weatherInfoView = WeatherInfoView()
        weatherInfoView.configure(with: data)
        presentModal(with: weatherInfoView)
    }

    func showWeatherModal(with response: WeatherResponse) {
        let weatherInfoView = WeatherInfoView()
        weatherInfoView.configure(with: response)
        presentModal(with: weatherInfoView)
    }

    func failedFetchCurrentWeather(error: String) {
        showToast(message: error, state: .critical)
    }

    private func presentModal(with modalView: UIView) {
        let modalViewController = ModalViewController(modalContentView: modalView)
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        present(modalViewController, animated: true, completion: nil)
    }
}
