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
            heroes.append(HeroListModel(id: heroRealm._id, name: heroRealm.name, thumbnail: URL(string: heroRealm.thumbnail)!))
        }
        return heroes
    }
}
