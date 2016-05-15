//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Benny on 4/2/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: ViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pin: Pin!
    
    private var photos = []
    
    private let space: CGFloat = 3.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestPhotosData()
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
    
    private func requestPhotosData() {
    
        let flickrApi = FlickrAPI(urlPath: FlickrPath.ServicesRest)
        
        flickrApi.urlParameters = [
            "method": "flickr.photos.search",
            "api_key": Constant.Flickr.apiKey,
            "lat": pin.latitude,
            "lon": pin.longitude,
            "extras": "url_q,url_m",
            "format": "json",
            "nojsoncallback": 1,
            "content_type": 1,
            "safe_search": 1,
            "per_page": 24,
            "page": 1
        ]
        
        connectionManager.httpRequest(requestAPI: flickrApi) { (response, success, errorMessage) in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                if success {
                    
                    if let data = response as? JSON, let results = data["photos"] as? JSON {
                        
                        print(results)
                        
                        if let photo = results["photo"] as? JSONArray {
                            
                            self.photos = photo
                            self.collectionView.reloadData()
                        }
                        
                    } else {
                        
                        print("errorrr")
                    }
                    
                } else if let message = errorMessage {
                    
                    print(message)
                    
                } else {
                    
                    print("?")
                }
            })
            
        }

    }

}

// MARK: UICollectionViewDataSource
extension PhotoAlbumViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoAlbumCell", forIndexPath: indexPath) as! PhotoAlbumCell
        
        cell.configureWithData(photos[indexPath.row] as! JSON)
        
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

