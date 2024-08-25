//
//  CommosExtension.swift
//  Weather
//
//  Created by Oscar Sierra Zuñiga on 22/08/24.
//

import UIKit

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else {
            return nil
        }
        
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

extension UIView {
    func fillViewWith(_ view: UIView, top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0, zindex: Int? = nil) {
        view.translatesAutoresizingMaskIntoConstraints = false
        if let zindex = zindex {
            insertSubview(view, at: zindex)
        } else {
            addSubview(view)
        }

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: top),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottom),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailing)
        ])
    }

    class var viewId: String {
        return "\(self)"
    }

    func addBlurEffect(effect: UIBlurEffect.Style = .dark) {
        let blurEffect = UIBlurEffect(style: effect)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }

    func addRoundCorner(point: CGFloat = 8.0) {
        layer.cornerRadius = point
        clipsToBounds = true
    }
}

extension UIFont {
    public enum nameOf: String {
    case Georgia_BoldItalic = "Georgia-BoldItalic"
    case Georgia_Italic = "Georgia-Italic"
    case Georgia = "Georgia"
    case Georgia_Bold = "Georgia-Bold"
    }
}

extension String {
    func getDateInString(outputFormat: String = "dd/MMMM/YYYY") -> String? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormat.timeZone = TimeZone(abbreviation: "GMT")
        
        if let date = dateFormat.date(from: self) {
            dateFormat.dateFormat = outputFormat
            return dateFormat.string(from: date)
        }
        
        return nil
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string: \(urlString)")
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to decode image from data")
                return
            }
            
            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
