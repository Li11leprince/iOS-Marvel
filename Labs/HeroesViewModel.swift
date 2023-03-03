//
//  HeroesViewModel.swift
//  Labs
//
//  Created by Effective on 19.02.2023.
//

import Foundation

class HeroesViewModel {
    
    var itemViewModels: [HeroCellViewModel] = []
    var detailPageViewModel: [DetailPageViewModel] = []
    
    private let heroes: [HeroModel] = [
        HeroModel(
            name: "Deadpool",
            backgroundColor: "Red",
            imageURL: URL(string: "https://pulse.imgsmail.ru/imgpreview?mb=pulse&key=pic1608069054751016742")!,
            description: "Say the magic words, Fat Gandalf"
        ),
        HeroModel(
            name: "Iron Man",
            backgroundColor: "Red",
            imageURL: URL(string: "https://img2.akspic.ru/crops/1/6/0/7/3/137061/137061-figurka-kostyum_aktera-vymyslennyj_personaz-cifrovoe_iskusstvo-supergeroj-750x1334.jpg")!,
            description: "I am Iron Man"
        ),
        HeroModel(
            name: "Capitan America",
            backgroundColor: "Red",
            imageURL: URL(string: "https://img2.akspic.ru/crops/8/1/2/6/6/166218/166218-kapitan_amerika-komiksy_marvel-kinovselennaya_marvel-shhit_kapitana_ameriki-supergeroj-1080x1920.jpg")!,
            description: "That is America's ass"
        ),
        HeroModel(
            name: "Spider man",
            backgroundColor: "Red",
            imageURL: URL(string: "https://i.pinimg.com/564x/0f/e2/64/0fe26480977cc56905bd9b2d2651f007.jpg")!,
            description: "With great power comes great responsibility"
        ),
        HeroModel(
            name: "Doctor Strange",
            backgroundColor: "Red",
            imageURL: URL(string: "https://s2.best-wallpaper.net/wallpaper/iphone/1609/Doctor-Strange-Marvel-hero_iphone_828x1792.jpg")!,
            description: "It was the only way"
        )
    ]
    
    init() {
        itemViewModels = heroes.enumerated().map { index, hero -> HeroCellViewModel in
            HeroCellViewModel(name: hero.name, imageURL: hero.imageURL)
        }
        detailPageViewModel = heroes.enumerated().map{ index, hero -> DetailPageViewModel in
            DetailPageViewModel(name: hero.name, imageURL: hero.imageURL, description: hero.description)
        }
    }
}
