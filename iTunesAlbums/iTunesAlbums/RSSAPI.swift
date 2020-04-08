//
//  RSSAPI.swift
//  iTunesAlbums
//
//  Created by Nicholas Bonat on 4/1/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

import UIKit

struct feeds: Codable {
    var results: [results?]
}

struct results: Codable {
    var artistName: String?
    var name: String?
    var releaseDate: String?
    var artworkUrl100: String?
    var copyright: String?
    var url: String?
    var genres: [genres?]
}

struct genres: Codable {
    var name: String?
}

class RSSData: Codable {
    var feed: feeds?
}
