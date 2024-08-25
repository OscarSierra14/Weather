//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 23/08/24.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    private lazy var weatherIcon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(weatherIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(temperatureLabel)
        
        NSLayoutConstraint.activate([
            weatherIcon.heightAnchor.constraint(equalToConstant: 50.0),
            weatherIcon.widthAnchor.constraint(equalToConstant: 50.0),
            weatherIcon.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            weatherIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
            nameLabel.leadingAnchor.constraint(equalTo: weatherIcon.trailingAnchor, constant: 16.0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            
            temperatureLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 3.0),
            temperatureLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(with data: SavedLocation) {
        guard let iconStringURL = data.icon,
              let name = data.savedName
        else {
            return
        }
        weatherIcon.loadImage(from: iconStringURL)
        nameLabel.text = name
        temperatureLabel.text = data.formattedTemperature()
    }

    private func kelvinToCelsius(_ kelvin: Double) -> Double {
        return kelvin - 273.15
    }

    private func formattedTemperature(_ celsius: Double) -> String {
        return String(format: "%.1f°C", celsius)
    }
}
