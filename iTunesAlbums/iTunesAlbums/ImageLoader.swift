//
//  ImageLoader.swift
//  iTunes Albums
//
//  Created by Nicholas Bonat on 4/6/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

// from help on stackoverflow
class ImageLoader: UIImageView {
    var imageURL: String?

    func loadFromURL(_ urlString: String) {
        imageURL = urlString
        image = nil
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        guard let url = URL(string: urlString) else { return }
        
        // image is not in cache: retrieve it from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    
                    // make sure the image matches the correct cell
                    if self.imageURL == urlString {
                        self.image = imageToCache
                    } 
                }
            })
        }).resume()
    }
}
