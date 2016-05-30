//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Benny on 4/2/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsMapViewController: ViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var editBarButton: EditBarButton!
    
    private let height: CGFloat = 60
    private var alreadyLoaded: Bool = false
    private lazy var bottomView: UIView = {
        return self.viewForBottom()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.setRegion(user.previousRegion, animated: false)
        
        mapView.delegate = self
        
        if !alreadyLoaded, let pins = frc.fetchedObjects as? [Pin] {
            for pin in pins {
                mapView.addAnnotation(pin.annotation)
            }
            alreadyLoaded = true
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "albumViewSegue", let pin = sender as? Pin {
            
            let controller = segue.destinationViewController as! PhotoAlbumViewController
            
            controller.pin = pin
        }
    }
    
    private func setupMapView() {
        
        view.addSubview(bottomView)
        
        let request = Pin.sortedFetchRequest
        request.returnsObjectsAsFaults = false
        frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: managedObjectContext,
                                             sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            
        }
    }

    @IBAction func handleEditButtonTapAction(sender: EditBarButton) {
        
        switch sender.status {
        case .Edit:
            sender.status = StatusButton.Done
            UIView.animateWithDuration(0.5, animations: {
                self.bottomView.frame.origin.y -= self.height
                self.mapView.frame.origin.y -= self.height
            })
            
            break
        case .Done:
            sender.status = StatusButton.Edit
            UIView.animateWithDuration(0.5, animations: {
                self.bottomView.frame.origin.y = self.view.frame.height
                self.mapView.frame.origin.y = 0
            })
            
            break
        }
    }
    
    private func viewForBottom() -> UIView {
        
        let bottomView = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height))
        bottomView.backgroundColor = UIColor.redColor()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: bottomView.frame.height))
        label.text = "Tap Pins to Delete"
        label.backgroundColor = .clearColor()
        label.textColor = .whiteColor()
        label.textAlignment = .Center
        bottomView.addSubview(label)
        return bottomView
    }
    
    
    @IBAction func handleMapLongPressGestureAction(sender: UILongPressGestureRecognizer) {
        
        if editBarButton.status == .Done { return }
        
        switch sender.state {
            
        case .Possible:
            break
        case .Began:
            break
        case .Changed:
            break
        case .Ended:
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = mapView.convertPoint(sender.locationInView(mapView), toCoordinateFromView: mapView)
            
            managedObjectContext.performChanges {
                
                Pin.insertIntoContext(
                    self.managedObjectContext,
                    t: LatLon(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                )
            }
            
            break
        case .Cancelled:
            break
        case .Failed:
            break
            
        }

    }

}

// MARK: MKMapViewDelegate
extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        user.previousRegion = mapView.region
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        } else {
            pinView!.annotation = annotation
        }
        pinView!.animatesDrop = true
        return pinView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if let annotation = view.annotation, let pin = Pin.findOrFetchPinInContext(managedObjectContext, t: LatLon(annotation.coordinate.latitude, annotation.coordinate.longitude)) {
            
            mapView.deselectAnnotation(annotation, animated: false)
            
            switch editBarButton.status {
                
            case .Edit:
                performSegueWithIdentifier("albumViewSegue", sender: pin)
                break
            case .Done:
                if let annotation = view.annotation {
                    
                    managedObjectContext.performChanges {
                        
                        self.managedObjectContext.deleteObject(pin)
                    }
                    
                    mapView.removeAnnotation(annotation)
                }
                break
            }
        }
    }
}

// MARK: NSFetchedResultsControllerDelegate
extension TravelLocationsMapViewController: NSFetchedResultsControllerDelegate {
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
            
        case .Insert:

            if let pin = anObject as? Pin {
                mapView.addAnnotation(pin.annotation)
            }
            break
            
        case .Delete:
            
            if let pin = anObject as? Pin {
                mapView.removeAnnotation(pin.annotation)
            }
            break
            
        case .Move:
            break
            
        case .Update:
            break
        }
    }
}



