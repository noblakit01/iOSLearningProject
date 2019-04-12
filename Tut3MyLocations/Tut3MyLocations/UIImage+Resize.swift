//
//  UIImage+Resize.swift
//  Tut3MyLocations
//
//  Created by luan on 6/30/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func resizedImagedWithBounds(bounds: CGSize) -> UIImage {
        let horizontalRadio = bounds.width / size.width
        let verticalRadio = bounds.height / size.height
        let radio = min(horizontalRadio, verticalRadio)
        let newSize = CGSize(width: size.width * radio, height: size.height * radio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        drawInRect(CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func resizedImagedWithBounds2(bounds: CGSize) -> UIImage {
        let horizontalRadio = bounds.width / size.width
        let verticalRadio = bounds.height / size.height
        let radio = max(horizontalRadio, verticalRadio)
        let newSize = CGSize(width: size.width * radio, height: size.height * radio)
        let origin = CGPoint(x: (bounds.width - newSize.width) / 2, y: (bounds.height - newSize.height) / 2)
        
        UIGraphicsBeginImageContextWithOptions(bounds, true, 0)
        drawInRect(CGRect(origin: origin, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}