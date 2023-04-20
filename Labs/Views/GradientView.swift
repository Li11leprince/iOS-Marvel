//
//  GradientView.swift
//  Labs
//
//  Created by Effective on 29.03.2023.
//

import UIKit

final class GradientView: UIView {
    private let colorTop = UIColor(hex: 0x000000, alpha: CGFloat(0)).cgColor
    private let colorBottom = UIColor(hex: 0x000000, alpha: CGFloat(0.9)).cgColor
    
    private lazy var gl: CAGradientLayer = {
        let gl = CAGradientLayer()
        gl.colors = [colorTop, colorBottom]
        gl.locations = [0.5, 0.9]
        return gl
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gl.frame = self.frame
        self.layer.insertSublayer(gl, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
