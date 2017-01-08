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
    
    fileprivate var manager: PhotoManager!
    
    fileprivate let space: CGFloat = 3.0
    
    fileprivate var selectedPhotos: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupCollectionView()
    }
    

    @IBAction func handleBarButtonItemTapAction(_ sender: CollectionBarButton) {
        
        sender.isEnabled = false
        
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
                       self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                    }
                    
                } else if let message = errorMessage {
                    self.presentAlertView(withTitle: "Error Message", message: message)
                    
                } else {
                    self.presentAlertView(message: "Sorry, something went wrong.")
                }
                
                sender.isEnabled = true
            })
            
            break
        case .Remove:
            
            for photo in selectedPhotos.reversed() {
                
                if let index = self.manager.removePhoto(photo) {
                    
                    self.collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
                }
            }
            
            selectedPhotos = []
            
            checkPhotoSelected()
            
            sender.isEnabled = true
            
            break
        }
    }
   
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        collectionView.isHidden = true
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        
        collectionView.reloadData()
        
        collectionView.isHidden = false
    }
    
    fileprivate func getDimension() -> CGFloat {
        
        return (self.view.frame.size.width - (2 * self.space)) / 3.0
    }
    
    fileprivate func setupMapView() {

        mapView.addAnnotation(pin.annotation)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude), span: MKCoordinateSpanMake(0.2, 0.2))
        
        mapView.setRegion(region, animated: false)
        
    }
    
    fileprivate func setupCollectionView() {
        
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
                        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                        self.barButtonItem.isEnabled = true
                    }
                } else if let message = errorMessage {
                    self.presentAlertView(withTitle: "Error Message", message: message)
                } else {
                    self.presentAlertView(message: "Sorry, something went wrong.")
                }
            })
            
        } else {
            
            collectionView.reloadData()
            barButtonItem.isEnabled = true
        }
    }
    
    fileprivate func showLabelWithMessage(_ active: Bool, message: String? = nil) {
        
        if active, let message = message {
            collectionView.isHidden = true
            messageLabel.text = message
        } else {
            collectionView.isHidden = false
            messageLabel.text = "No Images"
        }
        
    }
    
    fileprivate func checkPhotoSelected() {
        
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
    
    fileprivate func delete() {
        
    }
}

// MARK: UICollectionViewDataSource
extension PhotoAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.photosCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoAlbumCell", for: indexPath) as! PhotoAlbumCell
        
        cell.configureWithPhoto(manager.getPhotos()[indexPath.row], inContext: managedObjectContext)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedPhotos.append(manager.getPhotos()[indexPath.row])
        
        checkPhotoSelected()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if let index = selectedPhotos.index(of: manager.getPhotos()[indexPath.row]) {
            
            selectedPhotos.remove(at: index)
        }
        
        checkPhotoSelected()
    }
    
}

// MARK: UICollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dimension = getDimension()
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return space
    }
}


