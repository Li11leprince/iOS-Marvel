//
//  DetailPageViewModel.swift
//  Labs
//
//  Created by Effective on 03.03.2023.
//

import Foundation
import UIKit

protocol InsectDetailViewModel: AnyObject {
    
    var onLoadData: ((HeroDetailViewState) -> Void)? { get set }
    func start()
    
}

final class DetailPageViewModel {
    
    var onLoadData: ((HeroDetailViewState) -> Void)?
    
    private let rep = HeroRepositoryImp()
    private let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func start() {
        getHero()
    }
    
    func getHero() {
        onLoadData?(.loading)
        rep.getCharacter(id: id) { [weak self] (response, isOffline) in
            switch response {
            case .success(let hero):
                if isOffline {
                    self?.onLoadData?(.offline(hero))
                } else {
                    self?.onLoadData?(.loaded(hero))
                }
            case .failure(let error):
                self?.onLoadData?(.error(error))
            }
        }
    }
}
