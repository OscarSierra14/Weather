//
//  ModalViewController.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 23/08/24.
//

import UIKit

class ModalViewController: UIViewController {

    private var modalContentView: UIView?

    init(modalContentView: UIView) {
        self.modalContentView = modalContentView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        if let contentView = modalContentView {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(contentView)

            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissModal() {
        dismiss(animated: true, completion: nil)
    }
}
