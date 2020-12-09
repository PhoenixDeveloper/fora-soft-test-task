//
//  Album.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 09.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import Foundation

struct Album: Codable {
    let artistName: String
    let collectionName: String
    let trackCount: Int
    let genre: String
    private let artworkURLString: String

    var artworkURL: URL? {
        return URL(string: artworkURLString)
    }

    enum CodingKeys: String, CodingKey {
        case artistName
        case collectionName
        case trackCount
        case genre = "primaryGenreName"
        case artworkURLString = "artworkUrl100"
    }
}
