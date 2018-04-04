//
//  Extensions.swift
//  FlickrViewer
//
//  Created by Chi on 4/4/18.
//  Copyright © 2018 cammy. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    convenience init(hex: String) {
        var hexValue = hex
        if hex.hasPrefix("#") {
            hexValue = String(hex.suffix(from: hex.index(hex.startIndex, offsetBy: 1)))
        }
        var scanner = Scanner(string: hexValue)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        if !scanner.scanHexInt64(&rgbValue) {
            hexValue = "1EC1B4"
            scanner =  Scanner(string: hexValue)
            scanner.scanLocation = 0
            scanner.scanHexInt64(&rgbValue)
        }

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }


}
