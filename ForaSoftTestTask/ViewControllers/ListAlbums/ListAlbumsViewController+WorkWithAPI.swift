//
//  ListAlbumsViewController+WorkWithAPI.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 09.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import UIKit
import Alamofire

extension ListAlbumsViewController {
    func searchAlbums(searchText: String, completion: @escaping ([Album]) -> Void) {
        guard let searchTextEncoded = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = URL(string: "\(Constants.url)?entity=album&term=\(searchTextEncoded)&limit=200") else {
            return
        }
        AF.request(url).responseJSON  { responce in switch responce.result {
        case .success(let JSON):
            if let jsonDict = JSON as? NSDictionary,
                let results = jsonDict["results"],
                let jsonData = try? JSONSerialization.data(withJSONObject: results) {
                let albumsList = try! JSONDecoder().decode([Album].self, from: jsonData)

                completion(albumsList)
            }
        case .failure(let error):
            print(error)
            }
        }
    }
}
