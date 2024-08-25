//
//  WeatherInfoView.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 23/08/24.
//

import Foundation
import UIKit

class WeatherInfoView: UIView {
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false

        return image
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        addSubview(iconImage)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(temperatureLabel)

        NSLayoutConstraint.activate([
            iconImage.heightAnchor.constraint(equalToConstant: 50.0),
            iconImage.widthAnchor.constraint(equalToConstant: 50.0),
            iconImage.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            iconImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: iconImage.bottomAnchor, constant: 16.0),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5.0),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            temperatureLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5.0),
            temperatureLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
            temperatureLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
        ])
    }

    func configure(with weather: WeatherResponse) {
        iconImage.loadImage(from: weather.weather.first?.iconURL ?? "")
        nameLabel.text = weather.name
        descriptionLabel.text = weather.weather.first?.information
        temperatureLabel.text = weather.main.formattedTemperature()
    }

    func configure(with savedData: SavedLocation) {
        iconImage.loadImage(from: savedData.icon ?? "")
        nameLabel.text = savedData.savedName
        descriptionLabel.text = savedData.information
        temperatureLabel.text = savedData.formattedTemperature()
    }
}
