//
//  ViewController.swift
//  Labs
//
//  Created by Effective on 15.02.2023.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout

final class ViewController: UIViewController {

    var viewModel = HeroesViewModel()
    
    private let colors = [
        UIColor(hex: 0x760208).cgColor,
        UIColor(hex: 0x99151A).cgColor,
        UIColor(hex: 0x3D4DB2).cgColor,
        UIColor(hex: 0xD0151A).cgColor,
        UIColor(hex: 0x067A53).cgColor
    ]
    
    private enum Constraints {
        static let titleImageViewTopConstraintValue = CGFloat(80)
        static let titleImageViewLeftRightConstraintValue = CGFloat(128)
        static let titleImageViewHeightValue = CGFloat(32)
        
        static let titleLabelLeftRightValue = CGFloat(32)
        static let titleLabelTopValue = CGFloat(-24)
        
        static let collectionViewTopValue = CGFloat(-32)
        static let collectionViewBottomValue = CGFloat(48)
        static let collectionViewLeftRightValue = CGFloat(32)
    }
    
    private let titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo.png")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.text = "Choose your hero"
        uiLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(700))
        uiLabel.textColor = UIColor.white
        uiLabel.textAlignment = .center
        return uiLabel
    }()
    
    private let collectionView: UICollectionView = {
        let uiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewPagingLayout())
        uiCollectionView.register(HeroesCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HeroesCollectionViewCell.self))
        uiCollectionView.isPagingEnabled = true
        uiCollectionView.isUserInteractionEnabled = true
        let layout = CollectionViewPagingLayout()
        layout.numberOfVisibleItems = nil
        uiCollectionView.collectionViewLayout = layout
        uiCollectionView.showsHorizontalScrollIndicator = false
        uiCollectionView.clipsToBounds = true
        uiCollectionView.backgroundColor = .clear
        return uiCollectionView
    }()
    
    private var triangle: TriangleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    private func initialize() {
        view.backgroundColor = UIColor(red: 42/255, green: 39/255, blue: 43/255, alpha: 1)
        triangle = TriangleView(frame: view.frame)
        triangle.backgroundColor = .clear
        setUpHierarchy()
        setUpConstraints()
        configureCollectionView()
    }
    
    private func setUpHierarchy() {
        view.addSubview(triangle)
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }
    
    private func setUpConstraints() {
        titleImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constraints.titleImageViewLeftRightConstraintValue)
            make.top.equalToSuperview().inset(Constraints.titleImageViewTopConstraintValue)
            make.height.equalTo(Constraints.titleImageViewHeightValue)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constraints.titleLabelLeftRightValue)
            make.top.equalTo(titleImageView.snp.bottom).inset(Constraints.titleLabelTopValue)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(Constraints.collectionViewTopValue)
            make.bottom.equalToSuperview().inset(Constraints.collectionViewBottomValue)
            make.left.right.equalToSuperview()
        }
        
        triangle.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.itemViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemViewModel = viewModel.itemViewModels[indexPath.row]
        let cell: HeroesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeroesCollectionViewCell.self)  , for: indexPath) as! HeroesCollectionViewCell
        cell.viewModel = itemViewModel
        return cell
    }

}

extension ViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        triangle.changeTryangleColor(colors[page])
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailPageController = DetailPageController()
        detailPageController.entityModel = viewModel.detailPageViewModel[indexPath.row]
        navigationController?.pushViewController(detailPageController, animated: true)
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




