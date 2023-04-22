//
//  DetailPageController.swift
//  Labs
//
//  Created by Effective on 02.03.2023.
//

import UIKit
import SnapKit
import Kingfisher

enum HeroDetailViewState {
    case loading
    case loaded(HeroModel)
    case offline(HeroModel)
    case error(Error)
}

final class DetailPageController: UIViewController {
    
    private let viewModel: DetailPageViewModel
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
    
    private let loadingView = LoadingView()
    
    init(viewModel: DetailPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Initialize()
        
        viewModel.onLoadData = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.loadingView.start()
            case .loaded(let hero):
                self.loadingView.stop()
                self.setUpView(hero: hero)
            case .offline(let hero):
                self.loadingView.stop()
                self.setUpView(hero: hero)
                self.showToast(message: "Offline mode", font: .systemFont(ofSize: 14.0))
            case .error(let error):
                self.loadingView.stop()
                self.alert.message = error.localizedDescription
                self.present(self.alert, animated: true, completion: nil)
            }
        }
        viewModel.start()
    }
    
    private func setUpHierarchy() {
        view.addSubview(backgroundImageView)
        view.addSubview(gradientView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(loadingView)
    }
    
    private func setUpConstraints() {
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
