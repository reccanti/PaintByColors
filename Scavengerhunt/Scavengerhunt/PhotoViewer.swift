//
//  PhotoViewer.swift
//  Scavengerhunt
//
//  Created by Benjamin Wilcox on 2/6/15.
//  Copyright (c) 2015 Rafael Eduardo Lopez Montilla. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewer : UIViewController {
    
    let image = UIImage(named: "annie.jpg")
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        imageView.image = image
    }
    
    override func viewDidAppear(animated: Bool) {
        let w = image?.size.width
        let h = image?.size.height
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        let scaleFactor = screenWidth/w!
        
        //imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: h! * scaleFactor)
        //imageView.center = view.center\
        imageView.image = filterImage(image!)
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.center = view.center
    }
    
    func filterImage (image: UIImage) -> UIImage {
        
        // create the Core Image context
        let context = CIContext()
        
        // create a Core Image from the UIImage
        let convertedImage = CIImage(image: image)
        
        // create a filter
        let filter = TestFilter()
        filter.setValue(convertedImage, forKey: kCIInputImageKey)
        //filter.setValue(1.0, forKey: kCIInputIntensityKey)
        
        // apply the filter
        let result = UIImage(CIImage: filter.outputImage)
        
        return result!
    }
}
