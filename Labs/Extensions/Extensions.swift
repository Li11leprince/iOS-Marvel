//
//  Extensions.swift
//  Labs
//
//  Created by Effective on 16.03.2023.
//

import Foundation
import SnapKit
import UIKit

extension String {
    func inserted(_ newElement: Character, at: Index) -> String {
        var insertedString = self
        insertedString.insert(newElement, at: at)
        return insertedString
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = CGFloat(1.0)) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y  + (inputImage.extent.size.height * 0.7), z: inputImage.extent.size.width, w: inputImage.extent.size.height * 0.3)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension UIViewController {

    func showToast(message : String, font: UIFont) {

        let toastLabel = UILabel()
//        toastLabel.frame.size.width = 200
//        toastLabel.frame.origin = CGPoint(x: self.view.frame.size.width/2 - 100, y: 30)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toastLabel)
        toastLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveLinear, animations: {
            NSLayoutConstraint.activate([
                toastLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -80),
                toastLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 80)
            ])
            toastLabel.layoutIfNeeded()
        }, completion: nil)
        NSLayoutConstraint.activate([
            toastLabel.heightAnchor.constraint(equalToConstant: 32),
            toastLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 32),
        ])
        UIView.animate(withDuration: 4.0, delay: 1.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
