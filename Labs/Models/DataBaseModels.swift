//
//  DataBaseModels.swift
//  Labs
//
//  Created by Effective on 12.04.2023.
//

import Foundation
import RealmSwift

class RealmHeroListModel: Object {
    @Persisted(primaryKey: true) var _id: Int
    @Persisted var name: String = ""
    @Persisted var thumbnail: String = ""
    convenience init(id: Int, name: String, thumbnail: String) {
        self.init()
        self._id = id
        self.name = name
        self.thumbnail = thumbnail
    }
}

class RealmHeroModel: Object {
    @Persisted(primaryKey: true) var _id: Int
    @Persisted var name: String = ""
    @Persisted var thumbnail: String = ""
    @Persisted var descript: String = ""
    convenience init(id: Int, name: String, thumbnail: String, descript: String) {
        self.init()
        self._id = id
        self.name = name
        self.thumbnail = thumbnail
        self.descript = descript
    }
}
