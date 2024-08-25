//
//  CustomToast.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

enum ToastState {
    case critical
    case warning
    case info
}

class CustomToast: UILabel {
    let contentView = UIView()
    let messageLabel = UILabel()
    
    init(type: ToastState, message: String) {
        super.init(frame: .zero)
        setUpUI(type: type, message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI(type: ToastState, message: String) {
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.translatesAutoresizingMaskIntoConstraints = false

        messageLabel.textAlignment = .center
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .critical:
            contentView.backgroundColor = .red
            messageLabel.textColor = .white
        case .warning:
            contentView.backgroundColor = .yellow
            messageLabel.textColor = .black
        case .info:
            contentView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
        }
    }
    
    public func show() {
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        contentView.fillViewWith(messageLabel, leading: 16, trailing: -16)
        
        window.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 40),
            contentView.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            contentView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 40),
            contentView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -40)
        ])
        
        UIView.animate(withDuration: 1.0, delay: 4.0, options: .curveEaseIn, animations: { [weak self] in
            self?.contentView.alpha = 0
        }, completion: { [weak self] _ in
            self?.contentView.removeFromSuperview()
        })
    }

    public func hide(withDuration duration: Double = 1.0) {
        guard duration > .zero else {
            contentView.removeFromSuperview()
            return
        }
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            self?.contentView.alpha = 0
        }, completion: { [weak self] _ in
            self?.contentView.removeFromSuperview()
        })
    }
}

