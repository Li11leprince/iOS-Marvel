//
//  HeroListViewController.swift
//  Labs
//
//  Created by Effective on 15.02.2023.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout
import Kingfisher

enum HeroListViewState {
    case loading
    case loaded([HeroListModel])
    case offline([HeroListModel])
    case error(Error)
}

final class HeroListViewController: UIViewController {

    var heroes: [HeroListModel]?
    
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
    
    private var isDragging: Bool {
        return self.collectionView.isDragging
    }
    
    private lazy var viewModel = HeroesViewModel(scrollView: collectionView)
    
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
    
    private let layout = CollectionViewPagingLayout()
    private lazy var collectionView: UICollectionView = {
        layout.numberOfVisibleItems = nil
        let uiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        uiCollectionView.register(HeroesCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HeroesCollectionViewCell.self))
        uiCollectionView.isPagingEnabled = true
        uiCollectionView.isUserInteractionEnabled = true
        uiCollectionView.showsHorizontalScrollIndicator = false
        uiCollectionView.clipsToBounds = true
        uiCollectionView.backgroundColor = .clear
        return uiCollectionView
    }()
    
    private var triangle: TriangleView!
    
    private let loadingView = LoadingView()
    
    private let alert: UIAlertController = {
        let alert = UIAlertController(title: "Error!", message: "This is an alert.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            })
        )
        return alert
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
        viewModel.onChangeViewState = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .loading:
                self.loadingView.start()
            case .loaded(let heroList):
                self.setUpView(heroList)
            case .offline(let heroList):
                self.showToast(message: "Offline mode", font: .systemFont(ofSize: 14.0))
                self.setUpView(heroList)
            case .error(let error):
                self.loadingView.stop()
                self.alert.message = error.localizedDescription
                self.present(self.alert, animated: true, completion: nil)
            }
        }
        
        viewModel.start()
    }

    private func setUpView(_ heroes: [HeroListModel]) {
        loadingView.stop()
        self.heroes = heroes
        collectionView.reloadData()
        collectionView.performBatchUpdates({
            collectionView.collectionViewLayout.invalidateLayout()
        })
        changeTriangleColor()
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
        view.addSubview(loadingView)
    }
    
    private func setUpConstraints() {
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
    
    private func changeTriangleColor() {
        guard let image = heroes?[layout.currentPage].thumbnail else { return }
        KingfisherManager.shared.retrieveImage(with: image, options: nil, completionHandler: { result in
            switch result {
            case .success(let value):
                self.triangle.changeTryangleColor(value.image.averageColor?.cgColor ?? UIColor(hex: 0x760208).cgColor)
            case .failure(_):
                self.triangle.changeTryangleColor(UIColor(hex: 0x760208).cgColor)
            }
        })
    }
    
}

extension HeroListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        heroes?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemViewModel = heroes?[indexPath.row]
        let cell: HeroesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeroesCollectionViewCell.self)  , for: indexPath) as! HeroesCollectionViewCell
        cell.model = itemViewModel
        return cell
    }

}

extension HeroListViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        changeTriangleColor()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = DetailPageViewModel(id: heroes?[indexPath.row].id ?? 0)
        let detailPageController = DetailPageController(viewModel: viewModel)
        navigationController?.pushViewController(detailPageController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.refreshOrLoadMore(offset: scrollView.contentOffset)
    }
    
}
