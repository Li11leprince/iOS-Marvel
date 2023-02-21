//
//  HeroesCollectionViewCell.swift
//  Labs
//
//  Created by Effective on 18.02.2023.
//

import UIKit
import CollectionViewPagingLayout
import SnapKit

class HeroesCollectionViewCell: UICollectionViewCell {
    
    var viewModel: HeroCellViewModel? {
        didSet {
            updateViews()
        }
    }
    
    let heroCell = UIView()
    let heroImage = UIImageView()
    let heroNameLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        heroCell.layer.cornerRadius = 20
        heroCell.layer.masksToBounds = true
        contentView.addSubview(heroCell)
        heroCell.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        heroImage.contentMode = .scaleAspectFill
        heroCell.addSubview(heroImage)
        heroImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        heroNameLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(700))
        heroNameLabel.textColor = UIColor.white
        heroNameLabel.numberOfLines = 2
        heroNameLabel.lineBreakMode = .byWordWrapping
        heroCell.addSubview(heroNameLabel)
        heroNameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(40)
            make.width.equalTo(340 - 80)
        }
    }
    
    private func updateViews() {
        guard let viewModel = viewModel else {
             return
         }
        heroNameLabel.text = viewModel.name
        heroImage.image = viewModel.image
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

