//
//  BicyclePlace.swift
//  SaitamaBicycle
//
//  Created by luan on 7/17/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import Foundation

class BicyclePlace {
    var id: String
    var lat: Double
    var lng: Double
    var name: String
    
    init?(dictionary: [String: AnyObject]) {
        guard let id = dictionary[ServerHelper.ServerDefine.idKey] as? String else {
            return nil
        }
        
        guard let position = dictionary[ServerHelper.ServerDefine.locationKey] as? [String: AnyObject] else {
            return nil
        }
        
        guard let lat = position[ServerHelper.ServerDefine.latKey] as? Double else {
            return nil
        }
        
        guard let lng = position[ServerHelper.ServerDefine.lngKey] as? Double else {
            return nil
        }
        
        guard let name = dictionary[ServerHelper.ServerDefine.nameKey] as? String else {
            return nil
        }
        
        self.id = id
        self.lat = lat
        self.lng = lng
        self.name = name
    }
}