//
//  iTunesAlbumsTests.swift
//  iTunesAlbumsTests
//
//  Created by Nicholas Bonat on 4/1/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

import XCTest
@testable import iTunes_Albums

class iTunesAlbumsTests: XCTestCase {

    // valid url of album artwork
    let imgURL = "https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/dd/25/8c/dd258c8a-f804-785f-1268-ad3cac0db873/20UMGIM04591.rgb.jpg/200x200bb.png"
    
    let result = results()
    var albumDetails = AlbumViewModel(album: results())
    
    func testLoadImage() {
        let img = ImageLoader()
        XCTAssertNil(img.image)
        XCTAssertNotNil(img.loadFromURL(imgURL))
    }
    
    func testInitialModel() {
        
        // initial declaration of the class is empty
        XCTAssertNil(albumDetails.albumTitle)
        XCTAssertNil(albumDetails.artistName)
        XCTAssertNil(albumDetails.releaseDate)
        XCTAssertNil(albumDetails.imageURL)
        XCTAssertNil(albumDetails.copyright)
        XCTAssertNil(albumDetails.url)
    }
    
    func testPopulatedModel() {
        let result = results(artistName: "Lil Baby", name: "My Turn", releaseDate: "2020-02-28", artworkUrl100: "imgURL", copyright: "Quality Control Music", url: "url", genres: [genres(name: "Hip-Hop/Rap")])
        albumDetails = AlbumViewModel(album: result)
        
        // assert there are values
        XCTAssertNotNil(albumDetails.albumTitle)
        XCTAssertNotNil(albumDetails.artistName)
        XCTAssertNotNil(albumDetails.releaseDate)
        XCTAssertNotNil(albumDetails.imageURL)
        XCTAssertNotNil(albumDetails.genres)
        XCTAssertNotNil(albumDetails.copyright)
        XCTAssertNotNil(albumDetails.url)
        
        // assert DI is working
        XCTAssertEqual(result.name, albumDetails.albumTitle)
        XCTAssertEqual(result.artistName, albumDetails.artistName)
        XCTAssertEqual(result.releaseDate, albumDetails.releaseDate)
        XCTAssertEqual(result.artworkUrl100, albumDetails.imageURL)
        XCTAssertEqual(result.genres?.first?.name, albumDetails.genres?.first?.name)
        XCTAssertEqual(result.copyright, albumDetails.copyright)
        XCTAssertEqual(result.url, albumDetails.url)
        
        let music = [albumDetails]
        // check array holds correct data in correct index
        XCTAssertEqual(music.count, 1)
        let firstIndex = music.first
        XCTAssertEqual(firstIndex?.albumTitle, "My Turn")
    }
}
