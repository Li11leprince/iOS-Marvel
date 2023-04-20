//
//  DetailPageViewModel.swift
//  Labs
//
//  Created by Effective on 03.03.2023.
//

import Foundation
import UIKit

final class DetailPageViewModel {
    
    private let api = APIManager()
    private let db = DBManager()
    
    var isLoaded = false
    
    func getHero(id: Int, complition: @escaping (_ response: Swift.Result<HeroModel, Error>, _ isOffline: Bool) -> ()) {
        isLoaded = false
        api.getCharacter(id: id) { [weak self] (response) in
            switch response {
            case .success(let hero):
                self?.isLoaded = true
                self?.db.saveHero(hero: hero)
                complition(.success(hero), false)
            case .failure(let error):
                guard let dbData = self?.db.getHero(by: id) else {
                    complition(.failure(error), false)
                    return
                }
                self?.isLoaded = true
                complition(.success(dbData), true)
            }
        }
    }
}
