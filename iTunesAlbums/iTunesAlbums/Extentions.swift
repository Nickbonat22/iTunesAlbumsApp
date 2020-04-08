//
//  Extentions.swift
//  iTunes Albums
//
//  Created by Nicholas Bonat on 4/6/20.
//  Copyright © 2020 Nicholas Bonat. All rights reserved.
//
import UIKit

extension UIColor {
    // stackoverflow code
    // Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    // - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}

// set all labels to the specified font and size
extension UILabel {
    var substituteFontName : String {
        get { return self.font.fontName }
        set { self.font = UIFont(name: newValue, size: 20) }
    }
    func setFont(fName: String) {
        self.font = UIFont(name: fName, size: 20)
    }
}
