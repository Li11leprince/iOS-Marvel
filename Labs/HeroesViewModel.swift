//
//  HeroesViewModel.swift
//  Labs
//
//  Created by Effective on 19.02.2023.
//

import Foundation

class HeroesViewModel {
    
    var itemViewModels: [HeroCellViewModel] = []
    
    private let heroes: [HeroModel] = [
        HeroModel(
            heroName: "Deadpool",
            backgroundColor: "Red",
            imageName: "deadpool"
        ),
        HeroModel(
            heroName: "Iron Man",
            backgroundColor: "Red",
            imageName: "ironman"
        ),
        HeroModel(
            heroName: "Capitan America",
            backgroundColor: "Red",
            imageName: "capitanamerica"
        ),
        HeroModel(
            heroName: "Spider man",
            backgroundColor: "Red",
            imageName: "spider man"
        ),
        HeroModel(
            heroName: "Doctor Strange",
            backgroundColor: "Red",
            imageName: "doctorstrange"
        )
    ]
    
    init() {
        itemViewModels = heroes.enumerated().map { index, hero -> HeroCellViewModel in
            HeroCellViewModel(index: index, name: hero.heroName)
        }
    }
}
