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
    
    func analyzePixels() {
        let context = CIContext()
        let cg = context.createCGImage(inputImage, fromRect: inputImage!.extent())
        println(println(cg))
        
    }
    
    func outputImage() -> CIImage {
        
        // input image
        let img = inputImage!
        
        // input extent
        let extent = img.extent()
        
        // input count
        let count = 50
        
        // input scale
        let scale = 1.0
        
        let filter = CIFilter(name: "CIAreaHistogram")
        filter.setValue(img, forKey: kCIInputImageKey)
        //filter.setValue(extent, forKey: kCIInputExtentKey)
        filter.setValue(count, forKey: "InputCount")
        filter.setValue(scale, forKey: kCIInputScaleKey)
        
        println(filter.outputImage)
        let imgout = filter.outputImage!
        return filter.outputImage
    }
    
}