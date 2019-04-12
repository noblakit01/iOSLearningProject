//
//  Location+MKAnnotation.swift
//  Tut3MyLocations
//
//  Created by luan on 6/28/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import MapKit

extension Location: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        if locationDescription.isEmpty {
            return "No Description"
        } else {
            return locationDescription
        }
    }
    
    var subtitle: String? {
        return category
    }
}
