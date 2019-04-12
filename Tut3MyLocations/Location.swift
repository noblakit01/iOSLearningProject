//
//  Location.swift
//  Tut3MyLocations
//
//  Created by luan on 6/26/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Location: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var hasPhoto: Bool {
        return photoID != nil
    }
    
    var photoPath: String {
        assert(photoID != nil, "Try to get photo path of class Location when no photo ID set")
        let fileName = "Photo-\(photoID!.integerValue).jpg"
        
        return (applicationDocumentsDirectory as NSString).stringByAppendingPathComponent(fileName)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoPath)
    }
    
    func removePhotoFile() {
        if hasPhoto {
            let path = photoPath
            let fileManager = NSFileManager.defaultManager()
            if fileManager.fileExistsAtPath(path) {
                do {
                    try fileManager.removeItemAtPath(path)
                } catch {
                    print("Error removing file: \(error)")
                }
            }
        }
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let currentID = userDefaults.integerForKey("PhotoID")
        userDefaults.setInteger(currentID + 1, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
}
