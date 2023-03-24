//
//  DetailPageViewModel.swift
//  Labs
//
//  Created by Effective on 03.03.2023.
//

import Foundation
import UIKit

final class DetailPageViewModel {
    
    private let api = API()
    
    var isLoaded = false
    
    func getHero(complition: @escaping (_ heroes: [HeroModel], _ status: Bool) -> (), id: Int) {
        isLoaded = false
        api.getCharacter(completion: { [weak self] (heroes, status, message) in
            if status {
                let heroList = heroes!.data.results.enumerated().map{ index, hero -> HeroModel in HeroModel(id: hero.id, name: hero.name, description: hero.description, modified: hero.modified, thumbnail: URL(string: hero.thumbnail.path.inserted("s", at: hero.thumbnail.path.firstIndex(of: ":")!) + "." + hero.thumbnail.extension)!) }
                self?.isLoaded = true
                complition(heroList, true)
            } else {
                complition([], false)
            }
        }, id: id)
    }
}
