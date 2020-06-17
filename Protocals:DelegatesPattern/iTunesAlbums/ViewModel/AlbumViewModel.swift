//
//  AlbumViewModel.swift
//  iTunes Albums
//
//  Created by Nicholas Bonat on 5/21/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

// import uikit so I can get the screen size
import UIKit

struct AlbumViewModel {
    var albumTitle: String?
    var artistName: String?
    var releaseDate: String?
    var imageURL: String?
    var genres: [genres]?
    var copyright: String?
    var url: String?
    
    // font size depending on screen size
    var size: CGFloat {
        if UIScreen.main.bounds.width <= 375 {
            return CGFloat(Constants.smallFontSize)
        } else {
            return CGFloat(Constants.regularFontSize)
        }
    }
    
    // convert array of strings into comma separated string
    func getGenresString(album: AlbumViewModel) -> String {
        guard let genres = album.genres else {return ""}
        var genreString = ""
        for i in genres {
            if genres[genres.count - 1].name != i.name {
                genreString += "\(i.name ?? ""), "
            } else {
                genreString += "\(i.name ?? "")"
            }
        }
        return genreString
    }
    
    // Dependency Injection (DI)
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
