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
    
    func configure(with music: AlbumViewModel){
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
        let cellHeight = contentView.frame.height-20
    
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            background.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            background.heightAnchor.constraint(equalToConstant: cellHeight),
            background.widthAnchor.constraint(equalToConstant: cellHeight)
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
            thumbnailImageView.heightAnchor.constraint(equalToConstant: cellHeight),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: cellHeight)
        ])
    }
    
    func setupLabels(with music: AlbumViewModel) {
        addSubview(albumNameLabel)
        addSubview(artistNameLabel)
        
        let cellHeight = contentView.frame.height
        
        albumNameLabel.translatesAutoresizingMaskIntoConstraints = false
        albumNameLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            albumNameLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 0),
            albumNameLabel.leftAnchor.constraint(equalTo: background.rightAnchor, constant: 10),
            albumNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0),
            albumNameLabel.widthAnchor.constraint(equalToConstant: self.contentView.frame.size.width - cellHeight)
        ])
        
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.leftAnchor.constraint(equalTo: background.rightAnchor, constant: 10),
            artistNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10.0),
            artistNameLabel.widthAnchor.constraint(equalToConstant: self.contentView.frame.size.width - cellHeight)
        ])
        
        albumNameLabel.textColor = .black
        artistNameLabel.textColor = .darkGray
        
        albumNameLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
        artistNameLabel.font = UIFont(name: "AvenirNext-Medium", size: 17)
        
        albumNameLabel.text = music.albumTitle
        artistNameLabel.text = music.artistName
    }
}


