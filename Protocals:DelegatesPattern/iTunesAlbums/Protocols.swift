//
//  Protocols.swift
//  iTunes Albums
//
//  Created by Nicholas Bonat on 6/16/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//

protocol AlubumDelegate: class {
    func didTapCell(album: AlbumViewModel)
}
