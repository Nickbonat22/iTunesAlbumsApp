//
//  ShowAlbumsViewController.swift
//  iTunesAlbums
//
//  Created by Nicholas Bonat on 4/1/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

import UIKit

class ShowAlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // variables for views
    let tableView = UITableView()
    let activityView = UIActivityIndicatorView()
    var refresher: UIRefreshControl?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ShowAlbumsViewController.handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .gray
        return refreshControl
    }()
    
    let cellID = "cellAlbum"
    let placeholderID = "cellPlaceholder"
    
    // variables for getting album data
    var numberOfAlbums = 100
    var count = 1
    var music = [AlbumDetails]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // reset data structures for fresh data
        self.music = []
        getMusic()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
             navigationItem.largeTitleDisplayMode = .always
             navigationController?.navigationBar.prefersLargeTitles = true
        }
        showActivityIndicatory()
        getMusic()
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        // tableView has to be the first view in order to show ios 11 introduced large text animation
        view.addSubview(tableView)
        setupNav()
    }
    
    func setupNav(){
        extendedLayoutIncludesOpaqueBars = true;
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        
        // custom regular nav bar font
        let fontWay = [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 20)]
        navigationController?.navigationBar.titleTextAttributes = fontWay as [NSAttributedString.Key : Any]
        
        // custom large nav bar font
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 30) ?? UIFont.systemFont(ofSize: 30)]

        // add nav bar bottom color line
        navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        // Set the shadow color.
        navigationController?.navigationBar.shadowImage = lightGrayColor.as1ptImage()
        
        self.title = "Top \(self.numberOfAlbums) Albums"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showActivityIndicatory() {
        activityView.style = .large
        activityView.color = .gray
        activityView.center = self.view.center
        view.addSubview(activityView)
        activityView.startAnimating()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        // set row height so user can see the outline of the table while it is loading
        tableView.rowHeight = 130
        // register
        tableView.register(AlbumCell.self, forCellReuseIdentifier: self.cellID)
    }
    
    // get album name, artist name, release data, thumbnail, genre, copyright, and url from API, then add to array
    func getMusic(){
        if let rssURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/\(numberOfAlbums)/explicit.json") {
            URLSession.shared.dataTask(with: rssURL) {data, _, _ in
                if let data2 = data {
                    DispatchQueue.main.async(execute: {
                    do {
                        let json = try JSONDecoder().decode(RSSData.self, from: data2)
                        if let feed = json.feed{
                            let results = feed.results
                            for item in results{
                                
                                // if these values aren't nil, add them to these variables
                                guard let album = item?.name, let artist = item?.artistName, let date = item?.releaseDate, let img = item?.artworkUrl100, let genre = item?.genres.first, let copyright = item?.copyright, let url = item?.url else {
                                    return;
                                }
                                guard let genreName = genre?.name else{
                                    return;
                                }
                                
                                // fill model and add to music array
                                let albumDetails = AlbumDetails(count: self.count, albumTitle: album, artistName: artist, releaseDate: date, imageURL: img, genres: genreName, copyright: copyright, url: url)
                                self.music.append(albumDetails)
                                // using count as a primary key if necessary for future use, but not necessary right now
                                self.count += 1
                            }
                        }
                    }catch {
                        print("parsing failed")
                        print(error)
                    }
                        // api is finished: create array that will show the data for detailVC
                        self.activityView.stopAnimating()
                        self.setupTableView()
                        // add refresh ability once initial loading of table
                        self.tableView.addSubview(self.refreshControl)
                    }) // end dispatch queue
                } // end session
            }.resume()
        }
    }
    
    // configure table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return music.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! AlbumCell
        // get the correct index and configure the cell
        let album = music[indexPath.row]
        cell.configure(with: album)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let song = music[indexPath.row]
        
        // only show back button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // assign data to detailsVC and push controller onto nav stack
        let detailsVC = DetailsViewController()
        detailsVC.musicDetails = song
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
        
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = lightGrayColor
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .white
        }
    }
}
