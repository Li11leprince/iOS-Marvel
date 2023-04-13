//
//  ViewController.swift
//  Labs
//
//  Created by Effective on 15.02.2023.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout
import Kingfisher

final class ViewController: UIViewController {

    var heroes: [HeroListModel]?
    
    private var page = 0
    
    private var offset = 0
    
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
    
    private lazy var paginationManager: HorizontalPaginationManager = {
        let manager = HorizontalPaginationManager(scrollView: self.collectionView)
        manager.delegate = self
        return manager
    }()
    
    private var isDragging: Bool {
        return self.collectionView.isDragging
    }
    
    private let heroesViewModel = HeroesViewModel()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !heroesViewModel.isLoaded {
            loadingView.start()
            heroesViewModel.getHeroes(offset: 0) { (response, isOffline) in
                switch response {
                case .success(let heroes):
                    if isOffline {
                        self.showToast(message: "Offline mode", font: .systemFont(ofSize: 14.0))
                    }
                    self.loadingView.stop()
                    self.heroes = heroes
                    self.collectionView.reloadData()
                    self.layout.setCurrentPage(0)
                    self.collectionView.performBatchUpdates({
                        self.collectionView.collectionViewLayout.invalidateLayout()
                    })
                    self.triangle.changeTryangleColor(self.getImageAverageColor())
                case .failure(let error):
                    self.loadingView.stop()
                    self.alert.message = error.localizedDescription
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.setupPagination()
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
    
    private func getImageAverageColor() -> CGColor {
        var color = UIColor(hex: 0x760208).cgColor
        guard let heroes = heroes else {return color}
        KingfisherManager.shared.retrieveImage(with: heroes[layout.currentPage].thumbnail, options: nil, progressBlock: nil, completionHandler: { result in
            switch result {
            case .success(let value):
                color = value.image.averageColor?.cgColor ?? UIColor(hex: 0x760208).cgColor
            case .failure(_):
                color = UIColor(hex: 0x760208).cgColor
            }
        })
        return color
    }
    
}

extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        heroes?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemViewModel = heroes?[indexPath.row]
        let cell: HeroesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HeroesCollectionViewCell.self)  , for: indexPath) as! HeroesCollectionViewCell
        cell.viewModel = itemViewModel
        return cell
    }

}

extension ViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.triangle.changeTryangleColor(getImageAverageColor())
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailPageController = DetailPageController()
        detailPageController.id = heroes?[indexPath.row].id
        navigationController?.pushViewController(detailPageController, animated: true)
    }
    
}

extension ViewController: HorizontalPaginationManagerDelegate {
    
    private func setupPagination() {
        self.paginationManager.refreshViewColor = .clear
        self.paginationManager.loaderColor = .white
    }
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
            self.heroesViewModel.getHeroes(offset: 0) { (response, isOffline) in
                switch response {
                case .success(let heroes):
                    if isOffline {
                        self.showToast(message: "Offline mode", font: .systemFont(ofSize: 14.0))
                    }
                    self.heroes = heroes
                    self.collectionView.reloadData()
                    self.collectionView.performBatchUpdates({
                        self.collectionView.collectionViewLayout.invalidateLayout()
                    })
                    completion(true)
                case .failure(let error):
                    completion(false)
                    self.alert.message = error.localizedDescription
                    self.present(self.alert, animated: true, completion: nil)
                }
            }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        offset += 20
        self.heroesViewModel.getHeroes(offset: offset) { (response, isOffline) in
            switch response {
            case .success(let heroes):
                self.heroes! += heroes
                self.collectionView.reloadData()
                self.collectionView.performBatchUpdates({
                    self.collectionView.collectionViewLayout.invalidateLayout()
                })
                completion(true)
            case .failure(let error):
                completion(false)
                self.alert.message = error.localizedDescription
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    
}

//selfsizing cell
//difable datasource


