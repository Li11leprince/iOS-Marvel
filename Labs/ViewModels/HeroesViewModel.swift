//
//  HeroesViewModel.swift
//  Labs
//
//  Created by Effective on 19.02.2023.
//

import Foundation

final class HeroesViewModel {
    
    private let api = APIManager()
    private let db = DBManager()
    
    var isLoaded = false
    
    func getHeroes(offset: Int, complition: @escaping (_ response: Swift.Result<[HeroListModel], Error>, _ isOffline: Bool) -> ()) {
        isLoaded = false
        api.getAllCharacters(offset: offset) { [weak self] (response) in
            switch response {
            case .success(let heroes):
                self?.isLoaded = true
                self?.db.putHeroes(heroes: heroes)
                complition(.success(heroes), false)
            case .failure(let error):
                let dbData = self?.db.getHeroes() ?? []
                if dbData.isEmpty {
                    complition(.failure(error), false)
                } else {
                    self?.isLoaded = true
                    complition(.success(dbData), true)
                }
            }
        }
    }
}
