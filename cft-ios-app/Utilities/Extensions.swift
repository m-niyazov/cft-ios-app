//
//  Extensions.swift
//  CFT - Notes
//
//  Created by Muhamed Niyazov on 13.03.2021.
//  Copyright © 2021 Muhamed Niyazov. All rights reserved.
//

import Foundation
import UIKit


// MARK: - UIColor
extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
    static let mainRed = UIColor.rgb(red: 216, green: 34, blue: 53)
    
}
