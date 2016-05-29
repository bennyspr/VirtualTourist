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
    
    var pin: Pin!
    
    private var manager: PhotoManager!
    
    private let space: CGFloat = 3.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
//        photos = [
//            [
//                "farm": 7,
//                "height_m": 375,
//                "height_q": 150,
//                "id": 6176202752,
//                "isfamily": 0,
//                "isfriend": 0,
//                "ispublic": 1,
//                "owner": "56978609@N08",
//                "secret": "0ca0cfa15d",
//                "server": 6177,
//                "title": "Merony United Methodist Church",
//                "url_m": "https://farm7.staticflickr.com/6177/6176202752_0ca0cfa15d.jpg",
//                "url_q": "https://farm7.staticflickr.com/6177/6176202752_0ca0cfa15d_q.jpg",
//                "width_m": 500,
//                "width_q":150
//            ]
//        ]
    }
    
    @IBAction func handleNewCollectionTapAction(sender: AnyObject) {
        
        
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
    
    private func setupCollectionView() {
        
        manager = PhotoManager(pin: pin, inContext: managedObjectContext)
        
        if !manager.hasPhotos() {
            
            showLabelWithMessage(true, message: "Loading images...")
            
            manager.requestPhotos({ (success, errorMessage) in
                
                self.showLabelWithMessage(false)
                
                if success {
                    self.collectionView.reloadData()
                } else if let message = errorMessage {
                    self.presentAlertView(withTitle: "Error Message", message: message)
                } else {
                    self.presentAlertView(message: "Sorry, something went wrong.")
                }
            })
            
        } else {
            
            collectionView.reloadData()
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
}

// MARK: UICollectionViewDataSource
extension PhotoAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.getPhotos().count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumCell", forIndexPath: indexPath) as! PhotoAlbumCell
        
        print(indexPath.row)
        
        cell.configureWithPhoto(manager.getPhotos()[indexPath.row], inContext: managedObjectContext)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension PhotoAlbumViewController: UICollectionViewDelegate {
    
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
// MARK: NSFetchedResultsControllerDelegate
extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
            
        case .Insert:
            
           
            break
            
        case .Delete:
            
            
            break
            
        case .Move:
            break
            
        case .Update:
            break
        }
    }
}


