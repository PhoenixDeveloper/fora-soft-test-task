//
//  ApiService.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 22.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import Foundation
import Alamofire

final class ApiService {
    static let standart = ApiService()

    private init() {
    }

    func searchAlbums(searchText: String, completion: @escaping ([Album]?, Error?) -> Void) {
        guard let searchTextEncoded = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = URL(string: "\(Constants.url)?entity=album&term=\(searchTextEncoded)&limit=200") else {
                return
        }
        AF.request(url).responseJSON  { responce in switch responce.result {
        case .success(let JSON):
            if let jsonDict = JSON as? NSDictionary,
                let results = jsonDict["results"],
                let jsonData = try? JSONSerialization.data(withJSONObject: results) {
                let albumsList = try? JSONDecoder().decode([Album].self, from: jsonData)

                completion(albumsList, nil)
            }
        case .failure(let error):
            completion(nil, error)
            }
        }
    }

    func getSongs(albumName: String, albumId: Int, completion: @escaping ([Song]?, Error?) -> Void) {
        guard let albumNameEncoded = albumName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = URL(string: "\(Constants.url)?entity=song&term=\(albumNameEncoded)&limit=200") else {
            return
        }
        AF.request(url).responseJSON  { responce in switch responce.result {
        case .success(let JSON):
            if let jsonDict = JSON as? NSDictionary,
                let results = jsonDict["results"],
                let jsonData = try? JSONSerialization.data(withJSONObject: results) {
                let songList = try? JSONDecoder().decode([Song].self, from: jsonData)

                completion(songList?.filter({ $0.albumId == albumId }).sorted(), nil)
            }
        case .failure(let error):
            completion(nil, error)
            }
        }
    }
}
