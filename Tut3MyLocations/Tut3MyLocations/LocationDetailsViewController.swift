//
//  LocationDetailsViewController.swift
//  Tut3MyLocations
//
//  Created by luan on 6/24/16.
//  Copyright © 2016 luantran. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class LocationDetailsViewController: UITableViewController {

    weak var managedObjectContext: NSManagedObjectContext!
    var observer: AnyObject!
    
    @IBOutlet weak var decriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var placemark: CLPlacemark?
    var categoryName = "No Category"
    var date = NSDate()
    var descriptionText = ""
    var image: UIImage? {
        didSet {
            if let image = image {
                self.showImage(image)
            }
        }
    }
    
    weak var locationToEdit: Location? {
        didSet{
            if let location = locationToEdit {
                title = "Edit Location"
                descriptionText = location.locationDescription
                placemark = location.placemark
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
        }
    }
    
    private lazy var dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        print("Create Date Formatter")
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        return formatter
    }()
    
    // MARK: IBAction
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        
        let hudView = HudView.hudInView(navigationController!.view, animated: true)
        let location: Location
        
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedObjectContext) as! Location
        }
        location.locationDescription = decriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        
        if let image = image {
            if !location.hasPhoto {
                location.photoID = Location.nextPhotoID()
            }
            
            if let data = UIImageJPEGRepresentation(image, 0.5) {
                do {
                    try data.writeToFile(location.photoPath, options: .DataWritingAtomic)
                } catch {
                    print("Error writing file: \(error)")
                }
            }
        }
        
        let delayInSeconds = 0.6
        afterDelay(delayInSeconds) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalCoreDataError(error)
        }
    }
    
    // MARK: Notification
    
    func listenForBackgroundNotification() {
        observer = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationDidEnterBackgroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) { [weak self] _ in
            
            print("*** listenForBackgroundNotification Closure \(self)")
            
            if let strongSelf = self {
                if strongSelf.presentedViewController != nil {
                    strongSelf.dismissViewControllerAnimated(false, completion: nil)
                }
                strongSelf.decriptionTextView.becomeFirstResponder()
            }
        }
    }
    
    // MARK: Override UIViewController
    
    deinit {
        print("*** deinit \(self)")
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        
        latitudeLabel.text = String(format: "%.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = stringFromPlacemark(placemark)
        } else {
            addressLabel.text = "No Address Found"
        }
        
        dateLabel.text = formatDate(date)
        
        if let location = locationToEdit {
            if location.hasPhoto {
                if let image = location.photoImage {
                    showImage(image)
                }
            }
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
        
        listenForBackgroundNotification()
        
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.2)
        tableView.indicatorStyle = .White
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickCategory" {
            if let controller = segue.destinationViewController as? CategoryPickerViewController {
                controller.selectedCategoryName = categoryName
            }
        }
    }
    
    // MARK: Selector
    
    func hideKeyboard(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(tableView)
        let indexpath = tableView.indexPathForRowAtPoint(point)
        
        if indexpath != nil && indexpath!.section == 0 && indexpath!.row == 0 {
            return
        }
        
        decriptionTextView.resignFirstResponder()
    }
    
    // MARK: Unwind Segue
    
    @IBAction func categoryPickerDidPickCategory(segue: UIStoryboardSegue) {
        if let controller = segue.sourceViewController as? CategoryPickerViewController {
            categoryName = controller.selectedCategoryName
            categoryLabel.text = categoryName
        } else {
            print("WARN: Unwind Segue Fail - SourceViewController is not CategoryPickerViewController")
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            decriptionTextView.becomeFirstResponder()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            pickPhoto()
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch (indexPath.section, indexPath.row) {
        case (1, _):
            if imageView.hidden {
                return 44
            } else {
                if let image = image {
                    let height = 260 * image.size.height / image.size.width
                    imageView.frame.size.height = height
                    
                    return height + 20
                } else if let location = locationToEdit {
                    if let image = location.photoImage {
                        let height = 260 * image.size.height / image.size.width
                        imageView.frame.size.height = height
                        
                        return height + 20
                    }
                }
                return 280
            }
        case (2, 2):
            addressLabel.frame.size = CGSize(width: view.bounds.width - 115, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.width - addressLabel.frame.size.width - 15
            
            return addressLabel.frame.size.height + 20
        default:
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        cell.selectedBackgroundView = selectedView
    }
    
    // MARK: Helper function
    
    func formatDate(date: NSDate) -> String {
        return dateFormatter.stringFromDate(date)
    }
    
    func stringFromPlacemark(placemark: CLPlacemark) -> String {
        var text = ""
        
        text.addText(placemark.subThoroughfare)
        text.addText(placemark.thoroughfare, withSeparator: " ")
        text.addText(placemark.locality, withSeparator: ", ")
        text.addText(placemark.administrativeArea, withSeparator: ", ")
        text.addText(placemark.postalCode, withSeparator: " ")
        text.addText(placemark.country, withSeparator: ", ")
        
        return text
    }
}
