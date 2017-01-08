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
    
    fileprivate let height: CGFloat = 60
    fileprivate var alreadyLoaded: Bool = false
    fileprivate lazy var bottomView: UIView = {
        return self.viewForBottom()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
    }

    override func viewDidAppear(_ animated: Bool) {
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "albumViewSegue", let pin = sender as? Pin {
            
            let controller = segue.destination as! PhotoAlbumViewController
            
            controller.pin = pin
        }
    }
    
    fileprivate func setupMapView() {
        
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

    @IBAction func handleEditButtonTapAction(_ sender: EditBarButton) {
        
        switch sender.status {
        case .Edit:
            sender.status = StatusButton.Done
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomView.frame.origin.y -= self.height
                self.mapView.frame.origin.y -= self.height
            })
            
            break
        case .Done:
            sender.status = StatusButton.Edit
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomView.frame.origin.y = self.view.frame.height
                self.mapView.frame.origin.y = 0
            })
            
            break
        }
    }
    
    fileprivate func viewForBottom() -> UIView {
        
        let bottomView = UIView(frame: CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height))
        bottomView.backgroundColor = UIColor.red
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: bottomView.frame.height))
        label.text = "Tap Pins to Delete"
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .center
        bottomView.addSubview(label)
        return bottomView
    }
    
    
    @IBAction func handleMapLongPressGestureAction(_ sender: UILongPressGestureRecognizer) {
        
        if editBarButton.status == .Done { return }
        
        switch sender.state {
            
        case .possible:
            break
        case .began:
            break
        case .changed:
            break
        case .ended:
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
            
            managedObjectContext.performChanges {
                
                Pin.insertIntoContext(
                    self.managedObjectContext,
                    t: LatLon(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                )
            }
            
            break
        case .cancelled:
            break
        case .failed:
            break
            
        }

    }

}

// MARK: MKMapViewDelegate
extension TravelLocationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        user.previousRegion = mapView.region
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        } else {
            pinView!.annotation = annotation
        }
        pinView!.animatesDrop = true
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let annotation = view.annotation, let pin = Pin.findOrFetchPinInContext(managedObjectContext, t: LatLon(annotation.coordinate.latitude, annotation.coordinate.longitude)) {
            
            mapView.deselectAnnotation(annotation, animated: false)
            
            switch editBarButton.status {
                
            case .Edit:
                performSegue(withIdentifier: "albumViewSegue", sender: pin)
                break
            case .Done:
                if let annotation = view.annotation {
                    
                    managedObjectContext.performChanges {
                        
                        self.managedObjectContext.delete(pin)
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
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            
        case .insert:

            if let pin = anObject as? Pin {
                mapView.addAnnotation(pin.annotation)
            }
            break
            
        case .delete:
            
            if let pin = anObject as? Pin {
                mapView.removeAnnotation(pin.annotation)
            }
            break
            
        case .move:
            break
            
        case .update:
            break
        }
    }
}



