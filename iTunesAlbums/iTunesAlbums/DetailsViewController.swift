//
//  DetailsViewController.swift
//  iTunesAlbums
//
//  Created by Nicholas Bonat on 4/2/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // data passed to this view controller
    var musicDetails: AlbumDetails?
    var albumCover: UIImage?
    
    // views
    let centerView = UIView()
    var imageView = ImageLoader()

    // labels
    let artistName = UILabel()
    let genre = UILabel()
    let releaseDate = UILabel()
    let copyright = UILabel()
    
    // bottom button
    let itunesButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = true
        } 
        setupNavBar()
        createImageView()
        createButton()
        createLabels()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
    }
    
    // set up the header and assign title to the album
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        
        // set title 
        self.title = musicDetails?.albumTitle
    }
    
    // create the button that handles the fast app switch
    func createButton() {
        itunesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(itunesButton)
        
        NSLayoutConstraint.activate([
            itunesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itunesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            itunesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itunesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itunesButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        itunesButton.backgroundColor = .black
        itunesButton.setTitle("View in iTunes", for: .normal)
        itunesButton.tintColor = .white
        itunesButton.layer.cornerRadius = 40
        itunesButton.layer.borderWidth = 2
        itunesButton.layer.borderColor = UIColor.black.cgColor
        
        itunesButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    // fast app switch
    @objc func buttonAction(sender: UIButton) {
        if let urlString = musicDetails?.url {
            if let url = URL(string: urlString),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    // create the labels for artist, genre, release date, and copyright
    func createLabels() {
        artistName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(artistName)

        artistName.numberOfLines = 0
        NSLayoutConstraint.activate([
            artistName.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            artistName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            artistName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            artistName.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
        ])
        artistName.textColor = .black
        artistName.setFont(fName: "AvenirNext-Medium")
        
        // setup the remaining 3 labels
        labelHelper(label: genre, aboveLabel: artistName)
        labelHelper(label: releaseDate, aboveLabel: genre)
        labelHelper(label: copyright, aboveLabel: releaseDate)

        // assign text from dic to label
        artistName.text = musicDetails?.artistName ?? "Artist Name"
        genre.text = musicDetails?.genres ?? "Genre"
        releaseDate.text = musicDetails?.releaseDate ?? "Release Date"
        copyright.text = musicDetails?.copyright ?? "Copyright"
        
        // smaller font for copyright label
        copyright.font = UIFont(name: "AvenirNext-Regular", size: 10)
    }
    
    // do the same thing for all passed labels
    func labelHelper(label: UILabel, aboveLabel: UILabel) {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        // set to 0 and height is dynamic so label text will alwways fit on the screen
        label.numberOfLines = 0
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: aboveLabel.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
        ])
        label.textColor = .darkGray
        label.setFont(fName: "AvenirNext-Regular")
    }
    
    // create box shadow view and image to go in it
    func createImageView() {
        centerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerView)
        
        NSLayoutConstraint.activate([
            centerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 22),
            centerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerView.heightAnchor.constraint(equalToConstant: 250),
            centerView.widthAnchor.constraint(equalToConstant: 250),
        ])
        centerView.backgroundColor = .white
        centerView.layer.shadowColor = UIColor.black.cgColor
        centerView.layer.shadowOpacity = 1
        centerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        centerView.layer.shadowRadius = 4
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 250),
        ])
        
        // set image
        if let imgURL = musicDetails?.imageURL {
            self.imageView.loadFromURL(imgURL)
        }
    }
}

