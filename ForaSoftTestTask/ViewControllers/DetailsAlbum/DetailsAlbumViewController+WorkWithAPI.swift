//
//  DetailsAlbumViewController+WorkWithAPI.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 18.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import Foundation
import Alamofire

extension DetailsAlbumViewController {
    func getSongs(albumName: String, albumId: Int, completion: @escaping ([Song]) -> Void) {
        guard let albumNameEncoded = albumName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed),
            let url = URL(string: "\(Constants.url)?entity=song&term=\(albumNameEncoded)&limit=200") else {
            return
        }
        refreshControl.beginRefreshing()
        AF.request(url).responseJSON  { responce in switch responce.result {
        case .success(let JSON):
            if let jsonDict = JSON as? NSDictionary,
                let results = jsonDict["results"],
                let jsonData = try? JSONSerialization.data(withJSONObject: results) {
                let songList = try? JSONDecoder().decode([Song].self, from: jsonData)

                if let songList = songList {
                    completion(songList.filter({ $0.albumId == albumId }).sorted())
                } else {
                    print("No data")
                }
            }
        case .failure(let error):
            print(error)
            }
        }
    }
}
