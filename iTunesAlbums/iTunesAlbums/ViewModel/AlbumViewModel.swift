//
//  AlbumViewModel.swift
//  iTunes Albums
//
//  Created by Nicholas Bonat on 5/21/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//
import UIKit

struct AlbumViewModel {
    var albumTitle: String?
    var artistName: String?
    var releaseDate: String?
    var imageURL: String?
    var genres: [genres?]
    var copyright: String?
    var url: String?
    
    // font size depending on screen size
    var size: CGFloat {
        if UIScreen.main.bounds.width <= 375 {
            return 13
        } else {
            return 15
        }
    }
    
    func getGenresString(album: AlbumViewModel) -> String {
        let genres = album.genres
        var genreString = ""
        for i in genres {
            if genres[genres.count - 1]?.name != i?.name {
                genreString += "\(i?.name ?? ""), "
            } else {
                genreString += "\(i?.name ?? "")"
            }
        }
        return genreString
    }
    
    // dependency injection
    init(album: results) {
        self.albumTitle = album.name
        self.artistName = album.artistName
        self.releaseDate = album.releaseDate
        self.imageURL = album.artworkUrl100
        self.genres = album.genres ?? []
        self.copyright = album.copyright
        self.url = album.url
    }
}
