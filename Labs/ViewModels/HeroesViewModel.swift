//
//  HeroesViewModel.swift
//  Labs
//
//  Created by Effective on 19.02.2023.
//

import Foundation
import UIKit

protocol HeroesViewModelProtocol: HorizontalPaginationManagerDelegate {
    var onChangeViewState: ((HeroListViewState) -> Void)? { get set }
    func start()
    func refreshOrLoadMore(offset: CGPoint)
}

final class HeroesViewModel: HeroesViewModelProtocol {
    private let rep = HeroRepositoryImp()
    
    private var heroes: [HeroListModel] = []
    private var offset = 0
    
    private let scrollView: UIScrollView!
    private lazy var paginationManager: HorizontalPaginationManager = {
        let manager = HorizontalPaginationManager(scrollView: self.scrollView)
        manager.delegate = self
        return manager
    }()
    
    var onChangeViewState: ((HeroListViewState) -> Void)?
    
    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    func start() {
        getHeroes(offset)
    }
    
    func refreshOrLoadMore(offset: CGPoint) {
        paginationManager.setContentOffSet(offset)
    }
    
    func refreshAll(completion: @escaping (Bool) -> Void) {
        rep.getAllCharacters(offset: 0) { [weak self] (response, isOffline) in
            guard let self = self else { return }
            switch response {
            case .success(let heroes):
                self.heroes = heroes
                completion(true)
                if isOffline {
                    self.onChangeViewState?(.offline(self.heroes))
                } else {
                    self.onChangeViewState?(.loaded(self.heroes))
                }
            case .failure(let error):
                self.onChangeViewState?(.error(error))
                completion(false)
            }
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        offset += 20
        rep.getAllCharacters(offset: offset) { [weak self] (response, isOffline) in
            guard let self = self else { return }
            switch response {
            case .success(let heroes):
                if isOffline {
                    self.heroes = heroes
                    self.onChangeViewState?(.offline(self.heroes))
                } else {
                    self.heroes += heroes
                    self.onChangeViewState?(.loaded(self.heroes))
                }
                completion(true)
            case .failure(let error):
                self.onChangeViewState?(.error(error))
                completion(false)
            }
        }
    }
    
    private func getHeroes(_ offset: Int) {
        onChangeViewState?(.loading)
        rep.getAllCharacters(offset: 0) { [weak self] (response, isOffline) in
            switch response {
            case .success(let heroes):
                self?.heroes = heroes
                if isOffline {
                    self?.onChangeViewState?(.offline(self?.heroes ?? []))
                } else {
                    self?.onChangeViewState?(.loaded(self?.heroes ?? []))
                }
            case .failure(let error):
                self?.onChangeViewState?(.error(error))
            }
        }
    }
}
