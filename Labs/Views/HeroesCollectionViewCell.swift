//
//  HeroesCollectionViewCell.swift
//  Labs
//
//  Created by Effective on 18.02.2023.
//

import UIKit
import CollectionViewPagingLayout
import SnapKit
import Kingfisher

final class HeroesCollectionViewCell: UICollectionViewCell {
    
    var model: HeroListModel? {
        didSet {
            updateViews()
        }
    }
    
    private enum Constraints {
        static let heroNameLabelBottomConstraintValue = CGFloat(48)
        static let heroNameLabelLeftRightConstraintValue = CGFloat(40)
    }
    
    private let containerView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 20
        uiView.layer.masksToBounds = true
        return uiView
    }()
    let heroImageView: UIImageView = {
        let uiImageView = UIImageView()
        uiImageView.contentMode = .scaleAspectFill
        return uiImageView
    }()
    private lazy var gradientView: GradientView = {
        let gv = GradientView(frame: contentView.frame)
        gv.layer.isHidden = true
        return gv
    }()
    private let heroNameLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(700))
        uiLabel.textColor = UIColor.white
        uiLabel.numberOfLines = 2
        uiLabel.lineBreakMode = .byWordWrapping
        return uiLabel
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpHierarchy() {
        contentView.addSubview(containerView)
        containerView.addSubview(heroImageView)
        containerView.addSubview(gradientView)
        containerView.addSubview(heroNameLabel)
    }
    
    private func setUpConstraints() {
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(32)
            make.bottom.top.equalToSuperview()
        }
        heroImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        heroNameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(Constraints.heroNameLabelBottomConstraintValue)
            make.left.right.equalToSuperview().inset(Constraints.heroNameLabelLeftRightConstraintValue)
        }
    }
    
    private func updateViews() {
        guard let model = model else {
             return
         }
        heroNameLabel.text = model.name
        heroImageView.kf.indicatorType = .activity
        let imageURL = model.thumbnail
        heroImageView.kf.setImage(with: imageURL,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        gradientView.layer.isHidden = false
    }
    

}

extension HeroesCollectionViewCell: ScaleTransformView {
    var scaleOptions: ScaleTransformViewOptions {
        ScaleTransformViewOptions(
            minScale: 0.6,
            scaleRatio: 0.4,
            translationRatio: CGPoint(x: 0.66, y: 0.2),
            maxTranslationRatio: CGPoint(x: 2, y: 0),
            keepVerticalSpacingEqual: true,
            keepHorizontalSpacingEqual: true,
            scaleCurve: .linear,
            translationCurve: .linear
        )
    }

    func transform(progress: CGFloat) {
        applyScaleTransform(progress: progress)
    }

}

