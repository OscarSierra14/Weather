//
//  TabBarViewController.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let registerLocationVC = LocationRegistrationViewController()
        let registerNavController = UINavigationController(rootViewController: registerLocationVC)
        registerNavController.tabBarItem = UITabBarItem(title: "Register Location", image: UIImage(systemName: "plus.circle"), tag: 0)

         let weatherStatusVC = WeatherStatusViewController()
         let weatherNavController = UINavigationController(rootViewController: weatherStatusVC)
         weatherNavController.tabBarItem = UITabBarItem(title: "Weather Status", image: UIImage(systemName: "cloud.sun"), tag: 1)

        viewControllers = [registerNavController, weatherNavController]
    }
}
