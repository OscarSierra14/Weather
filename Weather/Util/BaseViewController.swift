//
//  BaseViewController.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

protocol BaseViewControllerLogic: AnyObject {
    func showToast(message: String, state: ToastState)
}

class BaseViewController: UIViewController, BaseViewControllerLogic {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showToast(message: String, state: ToastState) {
        let toast = CustomToast(type: state, message: message)
        toast.show()
    }
}
