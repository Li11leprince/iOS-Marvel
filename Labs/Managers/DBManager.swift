//
//  DBManager.swift
//  Labs
//
//  Created by Effective on 12.04.2023.
//

import Foundation
import RealmSwift
import Realm
import SwiftUI

protocol HeroDataBaseManager: AnyObject {
    
    func saveAllHeroes(heroes: [HeroListModel])
    func getAllHeroes() -> [HeroListModel]
    
    func getHero(by id: Int) -> HeroModel?
    func saveHero(hero: HeroModel)
    
}

final class DBManager {

    private let realm = try! Realm()
    func save<T: Object>(object: T) {
        try! realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func getById<T: Object>(by id: Int) -> T? {
        guard let objectRealm = realm.object(ofType: T.self, forPrimaryKey: id) else {
            return nil
        }
        return objectRealm
    }
    
    func getAll<T: Object>() -> [T] {
        var objects: [T] = []
        let objectsRealm = realm.objects(T.self)
        for objectRealm in objectsRealm {
            objects.append(objectRealm)
        }
        return objects
    }
}

extension DBManager: HeroDataBaseManager {
    
    func saveAllHeroes(heroes: [HeroListModel]) {
        let realmHeroes = heroes.enumerated().map{ index, hero -> RealmHeroListModel in
            let imageUrl = hero.thumbnail?.absoluteString ?? ""
            return RealmHeroListModel(id: hero.id, name: hero.name, thumbnail: imageUrl)
        }
        for realmHero in realmHeroes {
            save(object: realmHero)
        }
    }
    
    func saveHero(hero: HeroModel) {
        let realmHero = RealmHeroModel(id: hero.id, name: hero.name, thumbnail: hero.thumbnail?.absoluteString ?? "", descript: hero.description)
        save(object: realmHero)
    }
    
    func getHero(by id: Int) -> HeroModel? {
        guard let realmHero: RealmHeroModel = getById(by: id) else { return nil }
        return HeroModel(
            id: realmHero._id,
            name: realmHero.name,
            description: realmHero.descript,
            thumbnail: URL(string: realmHero.thumbnail)
        )
    }
    func getAllHeroes() -> [HeroListModel] {
        let realmHeroes: [RealmHeroListModel] = getAll()
        let heroes = realmHeroes.enumerated().map { index, realmHero -> HeroListModel in
            HeroListModel(
                id: realmHero._id,
                name: realmHero.name,
                thumbnail: URL(string: realmHero.thumbnail)
                )
        }
        return heroes
    }
}
