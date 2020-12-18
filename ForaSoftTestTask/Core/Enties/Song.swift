//
//  Song.swift
//  ForaSoftTestTask
//
//  Created by Михаил Беленко on 18.12.2020.
//  Copyright © 2020 MOB. All rights reserved.
//

import Foundation

struct Song: Codable, Comparable {
    let id: Int
    let albumId: Int
    let singer: String
    let songName: String
    let trackNumber: Int
    let trackTimeMillis: Int
    private let imageURLString: String
    private let trackURLString: String

    var imageURL: URL? {
        return URL(string: imageURLString)
    }

    var trackURL: URL? {
        return URL(string: trackURLString)
    }

    var trackTimeToString: String {
        let timeToSeconds: Int = trackTimeMillis / 1000
        return "\(timeToSeconds / 60):\(timeToSeconds % 60)"
    }

    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case albumId = "collectionId"
        case singer = "artistName"
        case songName = "trackName"
        case trackNumber
        case trackTimeMillis
        case imageURLString = "artworkUrl100"
        case trackURLString = "trackViewUrl"
    }

    static func < (lhs: Song, rhs: Song) -> Bool {
        return lhs.trackNumber < rhs.trackNumber
    }
}
