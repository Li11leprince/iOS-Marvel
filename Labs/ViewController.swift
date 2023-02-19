//
//  ViewController.swift
//  Labs
//
//  Created by Effective on 15.02.2023.
//

import UIKit
import SnapKit
import CollectionViewPagingLayout

class ViewController: UIViewController {

    var viewModel = HeroesViewModel()
    
    private let marvelLogo = UIImageView(image: UIImage(named: "logo.png"))
    private let chooseHeroLabel = UILabel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewPagingLayout())
    let context = UIBezierPath()
    let shapeLayer = CAShapeLayer()
    let customCellIdentifier = "customCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func initialize() {
        view.backgroundColor = UIColor(red: 42/255, green: 39/255, blue: 43/255, alpha: 1)

        marvelLogoLayout()

        chooseHeroLabelLayout()
        drawTriangle()
        configureCollectionView()
        

    }
    
    private func marvelLogoLayout() {
        view.addSubview(marvelLogo)
        marvelLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(80)
            make.width.equalTo(125)
            make.height.equalTo(35)
        }
    }
    
    private func chooseHeroLabelLayout() {
        chooseHeroLabel.text = "Choose your hero"
        chooseHeroLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight(700))
        chooseHeroLabel.textColor = UIColor.white
        view.addSubview(chooseHeroLabel)
        chooseHeroLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(140)
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(HeroesCollectionViewCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isUserInteractionEnabled = true
        let layout = CollectionViewPagingLayout()
        layout.numberOfVisibleItems = nil
        collectionView.collectionViewLayout = layout
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(220)
            make.bottom.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(27)
            make.right.equalToSuperview().inset(27)
        }
        
    }
    
    private func drawTriangle() {
        context.move(to: CGPoint(x: view.frame.minX, y: view.frame.maxY))
        context.addLine(to: CGPoint(x: view.frame.maxX, y: view.frame.maxY))
        context.addLine(to: CGPoint(x: (view.frame.maxX), y: view.frame.minY + 350))
        context.addLine(to: CGPoint(x: view.frame.minX, y: view.frame.maxY))
        
        shapeLayer.path = context.cgPath
        shapeLayer.fillColor = UIColor(rgb: 0x760208).cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    private func changeTryangleColor(_ color: CGColor) {
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = color
        shapeLayer.lineWidth = 1
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.itemViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemViewModel = viewModel.itemViewModels[indexPath.row]
        let cell: HeroesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! HeroesCollectionViewCell
        cell.viewModel = itemViewModel
        return cell
    }

}

extension ViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        var color: CGColor
        switch page {
        case 0: color = UIColor(rgb: 0x760208).cgColor
        case 1: color = UIColor(rgb: 0x99151A).cgColor
        case 2: color = UIColor(rgb: 0x3D4DB2).cgColor
        case 3: color = UIColor(rgb: 0xD0151A).cgColor
        case 4: color = UIColor(rgb: 0x067A53).cgColor

        default:
            color = UIColor.green.cgColor
        }
        changeTryangleColor(color)
    }

}

extension UIColor {
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}




