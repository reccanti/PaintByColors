//
//  PaletteView.swift
//  Scavengerhunt
//
//  Created by Benjamin Wilcox on 2/8/15.
//  Copyright (c) 2015 Rafael Eduardo Lopez Montilla. All rights reserved.
//

import Foundation
import UIKit

class PaletteView: UIView {
    
    var colorPalette: [Int] = []
    
    func setPalette(colors: [Int]) {
        for (var i = 0; i < colors.count; i++) {
            colorPalette.insert(colors[i], atIndex: i)
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        if (colorPalette.count > 3) {
            let paletteRect = CGRectMake(0, 0, 30, 30)
            UIGraphicsBeginImageContext(rect.size)
            let context = UIGraphicsGetCurrentContext()
            CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0)
            CGContextFillRect(context, paletteRect)
        }

    }
}