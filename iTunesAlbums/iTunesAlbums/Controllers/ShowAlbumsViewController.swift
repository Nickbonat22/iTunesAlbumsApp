//
//  ShowAlbumsViewController.swift
//  iTunesAlbums
//
//  Created by Nicholas Bonat on 4/1/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

import UIKit

protocol AlubumDelegate: class {
    func didTapCell(album: AlbumViewModel)
}

class ShowAlbumsViewController: UIViewController {
    
    // weak is used to avoid a retain cycle
    weak var albumDelegate: AlubumDelegate?
    
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
    
    // variables for getting album data
    var numberOfAlbums = 100
    var music = [AlbumViewModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        // reset data structures for fresh data
        self.music = []
        fetchData()
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
        fetchData()
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
        tableView.rowHeight = view.frame.height / 8
        // register
        tableView.register(AlbumCell.self, forCellReuseIdentifier: self.cellID)
    }
    
    // get album name, artist name, release data, thumbnail, genre, copyright, and url from API, then add to array
    fileprivate func fetchData() {
        Service.shared.fetchAlbums { (albums, err) in
            if let err = err {
                print("Failed to fetch courses:", err)
                return
            }
            
            // append to self.music using map
            self.music = albums?.map({return AlbumViewModel(album: $0)}) ?? []

            self.tableView.reloadData()
            self.activityView.stopAnimating()
            self.setupTableView()
            // add refresh ability once initial loading of table
            self.tableView.addSubview(self.refreshControl)
        }
    }
}

extension ShowAlbumsViewController:  UITableViewDelegate, UITableViewDataSource {
    // configure table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return music.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as? AlbumCell else {
            // show defualt cell
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
            return cell
        }
        // if cell is not nil: populate with the appropriate data
        let album = music[indexPath.row]
        cell.configure(with: album)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight:CGFloat = view.frame.height / 8
        return cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = music[indexPath.row]
        
        // only show back button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // assign data to detailsVC and push controller onto nav stack
        let detailsVC = DetailsViewController()
        albumDelegate.self = detailsVC
        albumDelegate?.didTapCell(album: album)
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
