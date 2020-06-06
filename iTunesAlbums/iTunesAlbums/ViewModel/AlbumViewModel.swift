//
//  AlbumViewModel.swift
//  iTunes Albums
//
//  Created by Nicholas Bonat on 5/21/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//
import UIKit


struct AlbumViewModel {
    var count: Int?
    var albumTitle: String?
    var artistName: String?
    var releaseDate: String?
    var imageURL: String?
    var genres: [genres?]
    var copyright: String?
    var url: String?
    
    
    func getGenres(album: AlbumViewModel) -> String {
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
    init(album: AlbumDetails) {
        self.count = album.count
        self.albumTitle = album.albumTitle
        self.artistName = album.artistName
        self.releaseDate = album.releaseDate
        self.imageURL = album.imageURL
        self.genres = album.genres
        self.copyright = album.copyright
        self.url = album.url
    }
}
