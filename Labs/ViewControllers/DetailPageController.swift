//
//  DetailPageController.swift
//  Labs
//
//  Created by Effective on 02.03.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailPageController: UIViewController {
    
    var id: Int!
    
    private let detailPageViewModel = DetailPageViewModel()
    private var hero: [HeroModel]!
    private enum Constraints {
        static let descriptionLabelBottomConstraintValue = CGFloat(56)
        static let descriptionLabelLeftRightConstraintValue = CGFloat(32)
        
        static let titleLabelBottomConstraintValue = CGFloat(-16)
        static let titleLabelLeftRightConstraintValue = CGFloat(32)
    }
    
    private let backgroundImageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFill
        return uiImageView
    }()
    
    private let titleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(700))
        uiLabel.textColor = UIColor.white
        uiLabel.numberOfLines = 2
        uiLabel.lineBreakMode = .byWordWrapping
        return uiLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(400))
        uiLabel.textColor = UIColor.white
        uiLabel.numberOfLines = 2
        uiLabel.lineBreakMode = .byWordWrapping
        return uiLabel
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        detailPageViewModel.getHero(complition: { (hero, status) in
            if status {
                self.hero = hero
                self.setUpView()
            }
        }, id: self.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
    }
    
    private func setUpHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func setUpConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constraints.descriptionLabelBottomConstraintValue)
            make.left.right.equalToSuperview().inset(Constraints.descriptionLabelLeftRightConstraintValue)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).inset(Constraints.titleLabelBottomConstraintValue)
            make.left.right.equalToSuperview().inset(Constraints.titleLabelLeftRightConstraintValue)
        }
    }
    
    private func setUpView() {
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: hero[0].thumbnail,
                                        placeholder: UIImage(named: "placeholderImage"),
                                        options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                    ])
        titleLabel.text = hero[0].name
        descriptionLabel.text = hero[0].description
    }
    
    private func Initialize() {
        setUpHierarchy()
        setUpConstraints()
        if detailPageViewModel.isLoaded {
            setUpView()
        }
    }
}
