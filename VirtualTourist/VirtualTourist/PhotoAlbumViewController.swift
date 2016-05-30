//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Benny on 4/2/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: ViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var barButtonItem: CollectionBarButton!
    
    var pin: Pin!
    
    private var manager: PhotoManager!
    
    private let space: CGFloat = 3.0
    
    private var selectedPhotos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupCollectionView()
    }
    

    @IBAction func handleBarButtonItemTapAction(sender: CollectionBarButton) {
        
        sender.enabled = false
        
        switch sender.status {
            
        case .New:
            
            showLabelWithMessage(true, message: "Loading new images...")
            
            manager.newCollection({ (success, errorMessage) in
                
                self.showLabelWithMessage(false)
                
                if success {
                    
                    self.collectionView.reloadData()
                    
                    if self.manager.photosCount() == 0 {
                        self.showLabelWithMessage(true, message: "No Photos Found.")
                    } else {
                       self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
                    }
                    
                } else if let message = errorMessage {
                    self.presentAlertView(withTitle: "Error Message", message: message)
                    
                } else {
                    self.presentAlertView(message: "Sorry, something went wrong.")
                }
                
                sender.enabled = true
            })
            
            break
        case .Remove:
            
            for photo in selectedPhotos.reverse() {
                
                if let index = self.manager.removePhoto(photo) {
                    
                    self.collectionView.deleteItemsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)])
                }
            }
            
            selectedPhotos = []
            
            checkPhotoSelected()
            
            sender.enabled = true
            
            break
        }
    }
   
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        
        collectionView.hidden = true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        
        collectionView.reloadData()
        
        collectionView.hidden = false
    }
    
    private func getDimension() -> CGFloat {
        
        return (self.view.frame.size.width - (2 * self.space)) / 3.0
    }
    
    private func setupMapView() {

        mapView.addAnnotation(pin.annotation)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude), span: MKCoordinateSpanMake(0.2, 0.2))
        
        mapView.setRegion(region, animated: false)
        
    }
    
    private func setupCollectionView() {
        
        collectionView.allowsMultipleSelection = true
        
        manager = PhotoManager(pin: pin, inContext: managedObjectContext)
        
        if !manager.hasPhotos() {
            
            showLabelWithMessage(true, message: "Loading images...")
            
            manager.requestPhotos({ (success, errorMessage) in
                
                self.showLabelWithMessage(false)
                
                if success {
                    self.collectionView.reloadData()
                    if !self.manager.hasPhotos() {
                        self.showLabelWithMessage(true, message: "No Photos Found.")
                    } else {
                        self.collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: false)
                        self.barButtonItem.enabled = true
                    }
                } else if let message = errorMessage {
                    self.presentAlertView(withTitle: "Error Message", message: message)
                } else {
                    self.presentAlertView(message: "Sorry, something went wrong.")
                }
            })
            
        } else {
            
            collectionView.reloadData()
            barButtonItem.enabled = true
        }
    }
    
    private func showLabelWithMessage(active: Bool, message: String? = nil) {
        
        if active, let message = message {
            collectionView.hidden = true
            messageLabel.text = message
        } else {
            collectionView.hidden = false
            messageLabel.text = "No Images"
        }
        
    }
    
    private func checkPhotoSelected() {
        
        if selectedPhotos.count > 0 {
            
            if selectedPhotos.count == 1 {
                barButtonItem.title = "Remove Selected Picture"
            } else {
                barButtonItem.title = "Remove Selected Pictures"
            }
            barButtonItem.status = CollectionStatusButton.Remove
            
        } else {
            
            barButtonItem.title = "New Collection"
            barButtonItem.status = CollectionStatusButton.New
        }
    }
    
    private func delete() {
        
    }
}

// MARK: UICollectionViewDataSource
extension PhotoAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.photosCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumCell", forIndexPath: indexPath) as! PhotoAlbumCell
        
        cell.configureWithPhoto(manager.getPhotos()[indexPath.row], inContext: managedObjectContext)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedPhotos.append(manager.getPhotos()[indexPath.row])
        
        checkPhotoSelected()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let index = selectedPhotos.indexOf(manager.getPhotos()[indexPath.row]) {
            
            selectedPhotos.removeAtIndex(index)
        }
        
        checkPhotoSelected()
    }
    
}

// MARK: UICollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let dimension = getDimension()
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return space
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return space
    }
}


