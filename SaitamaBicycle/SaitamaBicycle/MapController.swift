//
//  MapController.swift
//  SaitamaBicycle
//
//  Created by luan on 7/17/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController {
    
    var mapView: GMSMapView?
    
    override func loadView() {
        let camera = GMSCameraPosition.cameraWithLatitude(35.95, longitude: 139.55, zoom: 11)
        mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServerHelper.sharedInstance.delegate = self
        createMarkers(ServerHelper.sharedInstance.places)
    }
    
    func createMarkers(places: [BicyclePlace]) {
        for place in places {
            let position = CLLocationCoordinate2DMake(place.lat, place.lng)
            let marker = GMSMarker(position: position)
            marker.title = place.name
            marker.map = mapView
        }
    }
}

extension MapController: ServerHelperGetPlaceDelegate {
    func ServerGetPlaceSuccess(places: [BicyclePlace]) {
        createMarkers(places)
    }
}