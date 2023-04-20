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
    private enum Constraints {
        static let descriptionLabelBottomConstraintValue = CGFloat(56)
        static let descriptionLabelLeftRightConstraintValue = CGFloat(32)
        
        static let titleLabelBottomConstraintValue = CGFloat(-16)
        static let titleLabelLeftRightConstraintValue = CGFloat(32)
    }
    
    private let backgroundImageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFill
        uiImageView.clipsToBounds = true
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
        uiLabel.lineBreakMode = .byTruncatingTail
        return uiLabel
    }()
    
    private lazy var gradientView: GradientView = {
        let gv = GradientView(frame: view.frame)
        gv.layer.isHidden = true
        return gv
    }()
    
    private let alert: UIAlertController = {
        let alert = UIAlertController(title: "Error!", message: "This is an alert.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            })
        )
        return alert
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        detailPageViewModel.getHero(id: self.id) { (response, isOffline) in
            switch response {
            case .success(let hero):
                if isOffline {
                    self.showToast(message: "Offline mode", font: .systemFont(ofSize: 14.0))
                }
                self.setUpView(hero: hero)
            case .failure(let error):
                self.alert.message = error.localizedDescription
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
    }
    
    private func setUpHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(gradientView)
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
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setUpView(hero: HeroModel) {
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: hero.thumbnail,
                                        placeholder: UIImage(named: "placeholderImage"),
                                        options: [
                                            .scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(1)),
                                            .cacheOriginalImage
                                    ])
        titleLabel.text = hero.name
        descriptionLabel.text = hero.description
        gradientView.layer.isHidden = false
    }
    
    private func Initialize() {
        setUpHierarchy()
        setUpConstraints()
//        if detailPageViewModel.isLoaded {
//            setUpView()
//        }
    }
}
