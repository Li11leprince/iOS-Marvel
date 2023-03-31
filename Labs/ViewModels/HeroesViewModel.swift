//
//  HeroesViewModel.swift
//  Labs
//
//  Created by Effective on 19.02.2023.
//

import Foundation

final class HeroesViewModel {
    
    private let api = API()
    
    var isLoaded = false
    
    func getHeroes(complition: @escaping (_ heroes: [HeroModel], _ status: Bool, _ error: Error?) -> (), offset: Int) {
        isLoaded = false
        api.getAllCharacters(completion: { [weak self] (heroes, status, error) in
            if status {
                let heroList = heroes!.data.results.enumerated().map{ index, hero -> HeroModel in HeroModel(id: hero.id, name: hero.name, description: hero.description, modified: hero.modified, thumbnail: URL(string: hero.thumbnail.path.inserted("s", at: hero.thumbnail.path.firstIndex(of: ":")!) + "." + hero.thumbnail.extension)!) }
                self?.isLoaded = true
                complition(heroList, true, nil)
            } else {
                complition([], false, error)
            }
        }, offset: offset)
    }
}
