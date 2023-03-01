//
//  HeroCellViewModel.swift
//  Labs
//
//  Created by Effective on 18.02.2023.
//

import Foundation
import UIKit

struct HeroCellViewModel {
    let name: String
    var image: UIImage? {
        UIImage(named: name)
    }
}
