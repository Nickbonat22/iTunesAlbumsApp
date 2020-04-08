//
//  AlbumCell.swift
//  iTunesAlbums
//
//  Created by Nicholas Bonat on 4/1/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    var albumNameLabel = UILabel()
    var artistNameLabel = UILabel()
    let background = UIView()
    let thumbnailImageView = ImageLoader()
    
    func configure(with music: AlbumDetails){
        self.contentView.backgroundColor = .white
        
        if let imgURL = music.imageURL{
            setupImage(url: imgURL)
        }
        setupLabels(with: music)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
    }
    
    func setupImage(url: String){
        addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            background.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            background.heightAnchor.constraint(equalToConstant: 110.0),
            background.widthAnchor.constraint(equalToConstant: 110.0)
        ])
        
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 1
        background.layer.shadowOffset = CGSize(width: 0, height: 2)
        background.layer.shadowRadius = 3
        
        // load image
        thumbnailImageView.loadFromURL(url)

        background.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: background.topAnchor),
            thumbnailImageView.leftAnchor.constraint(equalTo: background.leftAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 110.0),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 110.0)
        ])
    }
    
    func setupLabels(with music: AlbumDetails) {
        addSubview(albumNameLabel)
        addSubview(artistNameLabel)
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            albumNameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 0),
            albumNameLabel.leftAnchor.constraint(equalTo: background.rightAnchor, constant: 10),
            albumNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0),
            albumNameLabel.widthAnchor.constraint(equalToConstant: self.contentView.frame.size.width - 125)
        ])
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 130),
            artistNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0),
            artistNameLabel.widthAnchor.constraint(equalToConstant: self.contentView.frame.size.width - 125)
        ])
        
        albumNameLabel.textColor = .black
        artistNameLabel.textColor = .darkGray
        
        albumNameLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
        artistNameLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
        
        albumNameLabel.text = music.albumTitle
        artistNameLabel.text = music.artistName
    }
}


