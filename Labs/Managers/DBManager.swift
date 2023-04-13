//
//  DBManager.swift
//  Labs
//
//  Created by Effective on 12.04.2023.
//

import Foundation
import RealmSwift
import SwiftUI

class DBManager {
    let realm = try! Realm()
    
    func putHeroes(heroes: [HeroListModel]) {
        for hero in heroes {
            try! realm.write {
                realm.add(HeroList(
                    id: hero.id,
                    name: hero.name,
                    thumbnail: hero.thumbnail
                ), update: .modified)
            }
        }
    }
    
    func getHeroes() -> [HeroListModel] {
        var heroes: [HeroListModel] = []
        let heroesRealm = realm.objects(HeroList.self)
        for heroRealm in heroesRealm {
            heroes.append(HeroListModel(
                id: heroRealm._id,
                name: heroRealm.name,
                thumbnail: URL(string: heroRealm.thumbnail)!))
        }
        return heroes
    }
    
    func putHero(hero: HeroModel) {
        try! realm.write {
            realm.add(Hero(
                id: hero.id,
                name: hero.name,
                thumbnail: hero.thumbnail,
                descript: hero.description
            ), update: .modified)
        }
    }
    
    func getHero(id: Int) -> HeroModel? {
        guard let heroRealm = realm.object(ofType: Hero.self, forPrimaryKey: id) else {
            return nil
        }
        return HeroModel(
            id: heroRealm._id,
            name: heroRealm.name,
            description: heroRealm.descript,
            thumbnail: URL(string: heroRealm.thumbnail)!
        )
    }
}
