//
//  ScavengerHuntItem.swift
//  Scavengerhunt
//
//  Created by Rafael Eduardo Lopez Montilla on 2/3/15.
//  Copyright (c) 2015 Rafael Eduardo Lopez Montilla. All rights reserved.
//

import UIKit

class ScavengerHuntItem: NSObject{
    let name: String
    var photo: UIImage?
    var isComplete: Bool {
        get {
            return photo != nil
        }
    }
    
    let NameKey = "nameKey"
    let PhotoKey = "photoKey"
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: NameKey)
        if let thePhoto = photo {
            aCoder.encodeObject(photo, forKey: PhotoKey)
        }
    }
    
    required init(coder aDecoder: NSCoder){
        name = aDecoder.decodeObjectForKey(NameKey) as String
        photo = aDecoder.decodeObjectForKey(PhotoKey) as? UIImage
    }
    
    init(name: String) {
        self.name = name
    }
}
