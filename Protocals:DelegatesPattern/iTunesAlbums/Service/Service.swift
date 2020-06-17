//
//  Service.swift
//  iTunesAlbums
//
//  Created by Nicholas Bonat on 4/1/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

import Foundation

class Service: NSObject {
    static let shared = Service()
    
    func fetchAlbums(completion: @escaping ([results]?, Error?) -> ()) {
        let urlString = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/\(Constants.totalAlbums)/explicit.json"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            // check for error
            if let err = err {
                completion(nil, err)
                print("Failed to fetch albums:", err)
                return
            }
            // check response
            guard let data = data else { return }
            do {
                let albumsJson = try JSONDecoder().decode(RSSData.self, from: data)
                let albums = albumsJson.feed?.results
                DispatchQueue.main.async {
                    completion(albums, nil)
                }
            // catch parsing error
            } catch let jsonErr {
                print("Parsing error:", jsonErr)
            }
        }.resume()
    }
}
