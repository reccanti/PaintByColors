//
//  TestFilter.swift
//  Scavengerhunt
//
//  Created by Benjamin Wilcox on 2/7/15.
//  Copyright (c) 2015 Rafael Eduardo Lopez Montilla. All rights reserved.
//

import Foundation
import UIKit

class TestFilter: CIFilter {
    
    var inputImage: CIImage?
    
    func outputImage() -> CIImage {
        
        let filter = CIFilter(name: "CIColorMatrix")
        filter.setValue(inputImage!, forKey: kCIInputImageKey)
        filter.setValue(CIVector(x: -1, y: 1, z: 1), forKey: "inputRVector")
        
        return filter.outputImage
    }
    
}