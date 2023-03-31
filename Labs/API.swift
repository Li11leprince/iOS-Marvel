//
//  API.swift
//  Labs
//
//  Created by Effective on 13.03.2023.
//

import Foundation
import Alamofire

final class API {
    private let baseURL = "https://gateway.marvel.com:443/v1/public"
    
    private lazy var parameters: [String: String] = [
        //"offset": String(describing: offset),
        "ts": "1",
        "apikey": "65c68fe6bf25193cc782ea92ced58111",
        "hash": "7d7fa28a489ed5667f31cab4431425f3"
    ]
    
    func getAllCharacters(completion: @escaping (_ heroes: APIHeroListModel?, _ status: Bool, _ error: Error?) -> Void, offset: Int) {
        AF.request(self.baseURL + "/characters?offset=\(String(describing: offset))", method: .get, parameters: self.parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: APIHeroListModel.self) { response in
            switch response.result {
            case .success:
                guard let data = response.value else {return}
                print(offset)
                completion(data, true, nil)
            case let .failure(error):
                completion(nil, false, error)
            }
        }
    }
    
    func getCharacter(completion: @escaping (_ heroes: APIHeroListModel?, _ status: Bool, _ error: Error?) -> Void, id: Int) {
        AF.request(self.baseURL + "/characters/\(id)", method: .get, parameters: self.parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseDecodable(of: APIHeroListModel.self) { response in
            switch response.result {
            case .success:
                guard let data = response.value else {return}
                completion(data, true, nil)
            case let .failure(error):
                completion(nil, false, error)
            }
        }
    }
}


//do {
//    let heroes = try JSONDecoder().decode(HeroModel.self, from: data)
//    self.heroesCallBack?(heroes, true,  "")
//} catch {
//    self.heroesCallBack?(nil, false, error.localizedDescription)
//    print(error)
//}
