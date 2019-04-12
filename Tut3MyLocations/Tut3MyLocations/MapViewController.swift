//
//  MapViewController.swift
//  Tut3MyLocations
//
//  Created by luan on 6/28/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextObjectsDidChangeNotification, object: managedObjectContext, queue: NSOperationQueue.mainQueue()) {
                notification in
                
                if let dictionary = notification.userInfo {
                    
                    for (key, value) in dictionary {
                        print("****** \(key) :::: \(value)")
                    }
                    
                    if let locations = dictionary["inserted"] as? Set<Location> {
                        for location in locations {
                            self.locations.append(location)
                            self.mapView.addAnnotation(location)
                        }
                    } else if let locations = dictionary["deleted"] as? Set<Location> {
                        for location in locations {
                            if let index = self.locations.indexOf(location) {
                                self.locations.removeAtIndex(index)
                                self.mapView.removeAnnotation(location)
                            }
                        }
                    } else if let locations = dictionary["updated"] as? Set<Location> {
                        for location in locations {
                            self.mapView.removeAnnotation(location)
                            self.mapView.addAnnotation(location)
                        }
                    }
                }
            }
        }
    }
    weak var managedObjectContext: NSManagedObjectContext!
    var locations = [Location]()
    
    // MARK: ViewController Work
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocations()
        
        if !locations.isEmpty {
            showLocations()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditLocation" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! LocationDetailsViewController
            
            controller.managedObjectContext = managedObjectContext
            
            let button = sender as! UIButton
            let location = locations[button.tag]
            controller.locationToEdit = location
        }
    }
    
    // MARK: IBAction
    
    @IBAction func showUser() {
        let region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func showLocations() {
        let region = regionForAnnotation(locations)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: Data
    
    func updateLocations() {
        mapView.removeAnnotations(locations)
        
        let entity = NSEntityDescription.entityForName("Location", inManagedObjectContext: managedObjectContext)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        locations = try! managedObjectContext.executeFetchRequest(fetchRequest) as! [Location]
        
        mapView.addAnnotations(locations)
    }
    
    func regionForAnnotation(annotations: [MKAnnotation]) -> MKCoordinateRegion {
        var region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 1000, 1000)
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 1000, 1000)
        default:
            var topLeftCoord = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRightCoord = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            
            for annotation in annotations {
                topLeftCoord.latitude = max(topLeftCoord.latitude, annotation.coordinate.latitude)
                topLeftCoord.longitude = min(topLeftCoord.longitude, annotation.coordinate.longitude)
                
                bottomRightCoord.latitude = min(bottomRightCoord.latitude, annotation.coordinate.latitude)
                bottomRightCoord.longitude = max(bottomRightCoord.longitude, annotation.coordinate.longitude)
            }
            
            let center = CLLocationCoordinate2D(latitude: (topLeftCoord.latitude + bottomRightCoord.latitude) / 2, longitude: (topLeftCoord.longitude + bottomRightCoord.longitude) / 2)
            let extraSpace = 1.1
            let span = MKCoordinateSpan(latitudeDelta: abs(topLeftCoord.latitude - bottomRightCoord.latitude) * extraSpace, longitudeDelta: abs(topLeftCoord.longitude - bottomRightCoord.longitude) * extraSpace)
            region = MKCoordinateRegion(center: center, span: span)
        }
        return region
    }
}