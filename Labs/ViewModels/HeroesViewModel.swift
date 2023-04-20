//
//  HeroesViewModel.swift
//  Labs
//
//  Created by Effective on 19.02.2023.
//

import Foundation

final class HeroesViewModel {
    
    private let rep = HeroRepositoryImp()
    private let db = DBManager()
    var isLoaded = false
    
    func getHeroes(offset: Int, complition: @escaping (_ response: Swift.Result<[HeroListModel], Error>, _ isOffline: Bool) -> ()) {
        isLoaded = false
        rep.getAllCharacters(offset: offset) { [weak self] (response) in
            switch response {
            case .success(let heroes):
                self?.isLoaded = true
                self?.db.saveAllHeroes(heroes: heroes)
                complition(.success(heroes), false)
            case .failure(let error):
                complition(.failure(error), false)
            }
        }
    }
}
