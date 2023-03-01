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
            name: "Deadpool",
            backgroundColor: "Red",
            imageName: "deadpool"
        ),
        HeroModel(
            name: "Iron Man",
            backgroundColor: "Red",
            imageName: "ironman"
        ),
        HeroModel(
            name: "Capitan America",
            backgroundColor: "Red",
            imageName: "capitanamerica"
        ),
        HeroModel(
            name: "Spider man",
            backgroundColor: "Red",
            imageName: "spider man"
        ),
        HeroModel(
            name: "Doctor Strange",
            backgroundColor: "Red",
            imageName: "doctorstrange"
        )
    ]
    
    init() {
        itemViewModels = heroes.enumerated().map { index, hero -> HeroCellViewModel in
            HeroCellViewModel(name: hero.name)
        }
    }
}
