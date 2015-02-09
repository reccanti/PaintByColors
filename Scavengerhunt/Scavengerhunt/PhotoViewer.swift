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
    @IBOutlet var imageView: UIImageView!

    @IBOutlet weak var drawView: PaletteView!

        
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
        
        view.setNeedsDisplay()
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
        
        /*
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
        */
        let gen = GPUImageHistogramGenerator()
        let hist = GPUImageHistogramFilter()
        hist.downsamplingFactor = 64
        let gamma = GPUImageGammaFilter()
        let pic = GPUImagePicture(image: image)
        
        pic.addTarget(gamma)
        gamma.addTarget(hist)
        
        //hist.addTarget(gen)
        //hist.forceProcessingAtSize(CGSize(width: 256, height: 256))
        
        //pic.addTarget(hist)
        hist.useNextFrameForImageCapture()
        pic.processImage()
    
        let final = hist.imageFromCurrentFramebuffer()
        getPixelData(final)
        
        return final
        
    }
    
    func getPixelData(image: UIImage) {
        
        let cg = image.CGImage
        let data = CGDataProviderCopyData(CGImageGetDataProvider(cg))
        let buf = CFDataGetBytePtr(data)
        
        let len = CFDataGetLength(data)
        
        for (var i = 0; i < len; i += 4) {
            println("line \(i/4)- red: \(buf[i]) green: \(buf[i+1]) blue: \(buf[i+2]) alpha: \(buf[i+3])")
        }
    }
    
    func genPalette(image: UIImage, numColors: Int = 16) -> [Int] {
        
        let filteredImage = filterImage(image)
        let cg = filteredImage.CGImage
        let data = CGDataProviderCopyData(CGImageGetDataProvider(cg))
        let buf = CFDataGetBytePtr(data)
        
        let len = CFDataGetLength(data)
        let lines = (len/4) as Int
        
        let start = (len/3) as Int
        let end = (2 * len/3) as Int
        
        let numRegions = numColors
        let linesInBlock = 4
        let blocksInRegion = ((end - start)/numRegions)/linesInBlock as Int
        
        var redVal = 0
        var greenVal = 0
        var blueVal = 0
        
        // get the average color of the image
        /*
        for (var i = start; i < end; i+=4) {
            redVal += Int(buf[i])
            greenVal += Int(buf[i+1])
            blueVal += Int(buf[i+2])
        }
*/
        
        var colorArray: [Int] = []
        let linesInRegion = (end - start)/numColors as Int
        for (var region = 0; region < numColors; region++) {
            
            var regionStart = start + (linesInRegion * region)
            var regionEnd = regionStart + linesInRegion
            
            redVal = 0
            greenVal = 0
            blueVal = 0
            
            for (var color = regionStart; color < regionEnd; color+=4) {
                
                redVal += Int(buf[color])
                greenVal += Int(buf[color+1])
                blueVal += Int(buf[color+2])
                
            }
            redVal = redVal/(linesInRegion/4)
            greenVal = greenVal/(linesInRegion/4)
            blueVal = blueVal/(linesInRegion/4)
            
            colorArray.append(redVal)
            colorArray.append(greenVal)
            colorArray.append(blueVal)
            
        }
        
        println(colorArray)
        /*
        redVal = redVal/((end-start)/4)
        greenVal = greenVal/((end-start)/4)
        blueVal = blueVal/((end-start)/4)
        */
        return colorArray

    }
    
    func drawPalette(colorArray: [Int]) {
        println(drawView.bounds)
        //drawView.setPalette(colorArray)
        //drawView.setNeedsDisplay()
        
        /*
        let rect = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetRGBFillColor(context, CGFloat(colorArray[0]), CGFloat(colorArray[1]), CGFloat(colorArray[2]), 255.0)
        CGContextFillRect(context, rect)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        imageView.image = finalImage
        */
        
        let numRows = 4
        let numCols = 4
        let tileHeight = Int(view.bounds.height / 4)
        let tileWidth = Int(view.bounds.width / 4)
        
        for (var i = 0; i < numRows; i++) {
            for (var j = 0; j < numCols; j++) {
                
                let currentX = CGFloat(tileWidth * j)
                let currentY = CGFloat(tileHeight * i)
                
                let pos = CGRectMake(currentX, currentY, CGFloat(tileWidth), CGFloat(tileHeight))
                let box = UIView(frame: pos)
                box.backgroundColor = UIColor(red: CGFloat(colorArray[j*3 + i*numCols])/255.0, green: CGFloat(colorArray[j*3 + 1 + i*numCols])/255.0, blue: CGFloat(colorArray[j*3 + 2 + i*numCols])/255.0, alpha: 1.0)
                self.view.addSubview(box)
            }
        }
        /*
        for (var i = 0; i < colorArray.count/3; i++) {
            let box = UIView(frame: CGRect(x: 0, y: 30*i, width: 30, height: 30))
            box.backgroundColor = UIColor(red: CGFloat(colorArray[i*3])/255.0, green: CGFloat(colorArray[i*3 + 1])/255.0, blue: CGFloat(colorArray[i*3 + 2])/255.0, alpha: 1.0)
            self.view.addSubview(box)
        }
*/
        
        //let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        //imageView.image = finalImage
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //self.dismissViewControllerAnimated(false, completion: {() -> Void in })
        //imagePicker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        let selectedImage = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let colorArray = genPalette(selectedImage)
        drawPalette(colorArray)
        //imageView.image = filterImage(selectedImage)
        
        didSelectImage = true
    }
    
}
