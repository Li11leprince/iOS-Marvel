//
//  LoadingView.swift
//  Labs
//
//  Created by Effective on 30.03.2023.
//

import UIKit

final class LoadingView: UIView {
    
    init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    func start() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        }
    }
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .red
        return activityIndicator
    }()
    
    private func setLayout() {
        alpha = 0
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(activityIndicator)
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
