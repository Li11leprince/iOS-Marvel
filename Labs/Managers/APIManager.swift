//
//  API.swift
//  Labs
//
//  Created by Effective on 13.03.2023.
//

import Foundation
import Alamofire

final class APIManager {
    private let baseURL = "https://gateway.marvel.com:443/v1/public"
    
    private lazy var parameters: [String: String] = [
        //"offset": String(describing: offset),
        "ts": "1",
        "apikey": "65c68fe6bf25193cc782ea92ced58111",
        "hash": "7d7fa28a489ed5667f31cab4431425f3"
    ]
    
    func getAllCharacters(offset: Int, completion: @escaping (_ response: Swift.Result<[HeroListModel], Error>) -> Void) {
        AF.request(self.baseURL + "/characters?offset=\(String(describing: offset))", method: .get, parameters: self.parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: APIHeroListModel.self) { response in
            switch response.result {
            case .success(let value):
                let heroList = value.data.results.enumerated().map{ index, hero -> HeroListModel in HeroListModel(id: hero.id, name: hero.name, thumbnail: URL(string: hero.thumbnail.path.inserted("s", at: hero.thumbnail.path.firstIndex(of: ":")!) + "." + hero.thumbnail.extension)!) }
                completion(.success(heroList))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getCharacter(id: Int, completion: @escaping (_ response: Swift.Result<HeroModel, Error>) -> Void) {
        AF.request(self.baseURL + "/characters/\(id)", method: .get, parameters: self.parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: APIHeroListModel.self) { response in
            switch response.result {
            case .success(let value):
                let hero = value.data.results.enumerated().map{ index, hero -> HeroModel in HeroModel(id: hero.id, name: hero.name, description: hero.description, thumbnail: URL(string: hero.thumbnail.path.inserted("s", at: hero.thumbnail.path.firstIndex(of: ":")!) + "." + hero.thumbnail.extension)!) }
                completion(.success(hero[0]))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Welcome
    private struct APIHeroListModel: Codable {
        let code: Int
        let status, copyright, attributionText, attributionHTML: String
        let etag: String
        let data: DataClass
    }

    // MARK: - DataClass
    private struct DataClass: Codable {
        let offset, limit, total, count: Int
        let results: [Result]
    }

    // MARK: - Result
    private struct Result: Codable {
        let id: Int
        let name, description: String
        let modified: String
        let thumbnail: Thumbnail
        let resourceURI: String
        let comics, series: Comics
        let stories: Stories
        let events: Comics
        let urls: [URLElement]
    }

    // MARK: - Comics
    private struct Comics: Codable {
        let available: Int
        let collectionURI: String
        let items: [ComicsItem]
        let returned: Int
    }

    // MARK: - ComicsItem
    private struct ComicsItem: Codable {
        let resourceURI: String
        let name: String
    }

    // MARK: - Stories
    private struct Stories: Codable {
        let available: Int
        let collectionURI: String
        let items: [StoriesItem]
        let returned: Int
    }

    // MARK: - StoriesItem
    private struct StoriesItem: Codable {
        let resourceURI: String
        let name: String
        let type: String
    }

    // MARK: - Thumbnail
    private struct Thumbnail: Codable {
        let path: String
        let `extension`: String
    }

    // MARK: - URLElement
    private struct URLElement: Codable {
        let type: String
        let url: String
    }
}

