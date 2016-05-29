//
//  PhotoManager.swift
//  VirtualTourist
//
//  Created by Benny on 5/21/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation
import CoreData

class PhotoManager {
    
    private var pin: Pin!
    private var moc: NSManagedObjectContext!
    private var photos: [Photo] = []
    
    lazy var connectionManager: ConnectionManager = {
        
        return ConnectionManager()
    }()
    
    init(pin: Pin, inContext moc: NSManagedObjectContext) {
        
        self.pin = pin
        self.moc = moc
        
        if hasPhotos() {
            self.photos = Array(self.pin.photos)
        }
    }
    
    func getPhotos() -> [Photo] {
        
        return photos
    }
    
    func hasPhotos() -> Bool {
        
        return pin.photos.count > 0
    }
    
    func requestPhotos(completion: (Bool, String?) -> Void) {
        
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
                        
                        if let photos = results["photo"] as? JSONArray {
                            
                            self.moc.performChanges {
                            
                                for photoData in photos {
                                    
                                    Photo.findOrCreatePhotoForPin(self.pin, inContext: self.moc, data: photoData)
                                }
                                
                                self.photos = Array(self.pin.photos)
                                completion(true, nil)
                            }
                            return
                        }
                    }
                    
                    completion(false, "There was an error reading the information received.")
                    
                } else if let message = errorMessage {
                    
                    completion(false, message)
                    
                } else {
                    
                    completion(false, "Something went wrong.")
                }
            })
            
        }
        
    }
}