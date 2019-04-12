//
//  MapViewController+UINavigationBarDelegate.swift
//  Tut3MyLocations
//
//  Created by luan on 6/28/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import UIKit

extension MapViewController: UINavigationBarDelegate {
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
    
}
