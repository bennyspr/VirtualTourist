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
    
    private lazy var user: User = {
        return User.sharedInstance
    }()
    
    private lazy var bottomView: UIView = {
        return self.viewForBottom()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bottomView)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        mapView.setRegion(user.previousRegion, animated: false)
        
        mapView.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "albumViewSegue" {
            
            let controller = segue.destinationViewController as! PhotoAlbumViewController
            
            
        }
    }

    @IBAction func handleEditButtonTapAction(sender: EditBarButton) {
        
        switch sender.status {
        case .Edit:
            sender.status = StatusButton.Done
            UIView.animateWithDuration(0.5, animations: {
                self.bottomView.frame.origin.y -= self.height
                self.mapView.frame.origin.y -= self.height
            }) { (finished) in
                
            }
            
            break
        case .Done:
            sender.status = StatusButton.Edit
            UIView.animateWithDuration(0.5, animations: {
                self.bottomView.frame.origin.y = self.view.frame.height
                self.mapView.frame.origin.y = 0
            }) { (finished) in
                
            }
            
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
        
        if editBarButton.status == .Done {
            return
        }
        
        switch sender.state {
            
        case .Began:
            print("Began")
            break
        case .Cancelled:
            print("Cancelled")
            break
        case .Changed:
            print("Changed")
            break
        case .Ended:
            
            let touchPoint = sender.locationInView(mapView)
            let touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            let pa = MKPointAnnotation()
            pa.coordinate = touchMapCoordinate
            pa.title = "Test"
            
            mapView.addAnnotation(pa)
            
            
            print("Ended")
            break
        case .Failed:
            print("Failed")
            break
        case .Possible:
            print("Possible")
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
        
        switch editBarButton.status {
        case .Edit:
                performSegueWithIdentifier("albumViewSegue", sender: nil)
            break
        case .Done:
            if let annotation = view.annotation {
                mapView.removeAnnotation(annotation)
            }
            break
        }
        
    }
}



