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
    let linkURL = "https://music.apple.com/us/album/my-turn/1498988850?app=music"
    
    var albumDetails = AlbumDetails()
    
    func testLoadImage() {
        let img = ImageLoader()
        XCTAssertNil(img.image)
        XCTAssertNotNil(img.loadFromURL(imgURL))
    }
    
    func testInitialModel() {
        // initial declaration of the class is empty
        XCTAssertNil(albumDetails.count)
        XCTAssertNil(albumDetails.albumTitle)
        XCTAssertNil(albumDetails.artistName)
        XCTAssertNil(albumDetails.releaseDate)
        XCTAssertNil(albumDetails.imageURL)
        XCTAssertNil(albumDetails.genres)
        XCTAssertNil(albumDetails.copyright)
        XCTAssertNil(albumDetails.url)
    }
    
    func testPopulatedModel() {
        albumDetails = AlbumDetails(count: 1, albumTitle: "My Turn", artistName: "Lil Baby", releaseDate: "2020-02-28", imageURL: imgURL, genres: "Hip-Hop/Rap", copyright: "Quality Control Music", url: linkURL)
        
        // assert there are values
        XCTAssertNotNil(albumDetails.count)
        XCTAssertNotNil(albumDetails.albumTitle)
        XCTAssertNotNil(albumDetails.artistName)
        XCTAssertNotNil(albumDetails.releaseDate)
        XCTAssertNotNil(albumDetails.imageURL)
        XCTAssertNotNil(albumDetails.genres)
        XCTAssertNotNil(albumDetails.copyright)
        XCTAssertNotNil(albumDetails.url)
        
        // assert values are correct
        XCTAssertEqual(albumDetails.count, 1)
        XCTAssertEqual(albumDetails.albumTitle, "My Turn")
        XCTAssertEqual(albumDetails.artistName, "Lil Baby")
        XCTAssertEqual(albumDetails.releaseDate, "2020-02-28")
        XCTAssertEqual(albumDetails.genres, "Hip-Hop/Rap")
        
        XCTAssertEqual(albumDetails.copyright, "Quality Control Music")
        
        let music = [albumDetails]
        // check array holds correct data in correct index
        XCTAssertEqual(music.count, 1)
        let firstIndex = music.first
        XCTAssertEqual(firstIndex?.albumTitle, "My Turn")
    }
}
