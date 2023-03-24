//
//  Extensions.swift
//  Labs
//
//  Created by Effective on 16.03.2023.
//

import Foundation
import UIKit

extension String {
    func inserted(_ newElement: Character, at: Index) -> String {
        var insertedString = self
        insertedString.insert(newElement, at: at)
        return insertedString
    }
}

extension UIColor {
    convenience init(hex: Int) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
