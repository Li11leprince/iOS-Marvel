//
//  ViewController.swift
//  Labs
//
//  Created by Effective on 15.02.2023.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout

public func delay(_ delay: Double, closure: @escaping () -> Void) {
    let deadline = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(
        deadline: deadline,
        execute: closure
    )
}

final class ViewController: UIViewController {

    var heroes: [HeroModel]?
    
    private var page = 0
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !heroesViewModel.isLoaded {
            heroesViewModel.getHeroes(complition: { (heroes, status) in
                if status {
                    self.heroes = heroes
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.layout.setCurrentPage(self.page)
                }
            }, offset: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.setupPagination()
        self.fetchItems()
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
        heroes?.count ?? 3
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
        let pageWidth = scrollView.frame.size.width
        page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        triangle.changeTryangleColor(colors[page % colors.count])
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailPageController = DetailPageController()
        detailPageController.id = heroes?[indexPath.row].id
        navigationController?.pushViewController(detailPageController, animated: true)
    }
    
}

extension ViewController: HorizontalPaginationManagerDelegate {
    
    private func setupPagination() {
        self.paginationManager.refreshViewColor = .green
        self.paginationManager.loaderColor = .red
    }
    
    private func fetchItems() {
        self.paginationManager.initialLoad()
    }
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        delay(2.0) {
            self.heroesViewModel.getHeroes(complition: { (heroes, status) in
                if status {
                    self.heroes = heroes
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.layout.setCurrentPage(self.page)
                }
            }, offset: 0)
            completion(true)
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
//        delay(2.0) {
//            self.items.append(contentsOf: [6, 7, 8, 9, 10])
//            self.collectionView.reloadData()
//            completion(true)
//        }
    }
    
}




