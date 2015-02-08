//
//  PhotoViewer.swift
//  Scavengerhunt
//
//  Created by Benjamin Wilcox on 2/6/15.
//  Copyright (c) 2015 Rafael Eduardo Lopez Montilla. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

class PhotoViewer : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var didSelectImage = false
    var image = UIImage(named: "annie.jpg")
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        /*
        getImage()
        
        let hist = GPUImageHistogramGenerator()
        let pic = GPUImagePicture(image: image)
        
        pic.addTarget(hist)
        hist.useNextFrameForImageCapture()
        hist.forceProcessingAtSize(CGSize(width: 256, height: 256))
        pic.processImage()
        let final = hist.imageFromCurrentFramebuffer()
        
        imageView.center = view.center
        imageView.image = final
        */
    }
    

    override func viewDidAppear(animated: Bool) {
        /*
        let w = image?.size.width
        let h = image?.size.height
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        
        let scaleFactor = screenWidth/w!
        
        //imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: h! * scaleFactor)
        //imageView.center = view.center\
        //imageView.image = filterImage(image!)
        imageView.center = view.center
        
        drawCustomImage(imageView.bounds.size)
        */
        /*
        let imagePicker = UIImagePickerController()
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        */
        /*
        getImage()
        
        let hist = GPUImageHistogramGenerator()
        let pic = GPUImagePicture(image: image)
        
        pic.addTarget(hist)
        hist.useNextFrameForImageCapture()
        hist.forceProcessingAtSize(CGSize(width: 256, height: 256))
        pic.processImage()
        let final = hist.imageFromCurrentFramebuffer()
        
        imageView.center = view.center
        imageView.image = final
        */
        
        // select an image from the camera or the photo library
        if (!didSelectImage) {
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
                imagePicker.sourceType = .Camera
            } else {
                imagePicker.sourceType = .PhotoLibrary
            }
        
            // present the user interface
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
        
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
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //self.dismissViewControllerAnimated(false, completion: {() -> Void in })
        //imagePicker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        let selectedImage = image
        self.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = selectedImage
        
        didSelectImage = true
    }
    
}
