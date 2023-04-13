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
    
    var isLoaded = false
    
    func getHero(id: Int, complition: @escaping (_ response: Swift.Result<HeroModel, Error>) -> ()) {
        isLoaded = false
        api.getCharacter(id: id) { [weak self] (response) in
            switch response {
            case .success(let hero):
                self?.isLoaded = true
                complition(.success(hero))
            case .failure(let error):
                complition(.failure(error))
            }
        }
    }
}
