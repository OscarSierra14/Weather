//
//  SceneDelegate.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene)
        else {
            return
        }
        
        window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarViewController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

