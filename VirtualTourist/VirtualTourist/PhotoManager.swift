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
    
    fileprivate var pin: Pin!
    fileprivate var moc: NSManagedObjectContext!
    fileprivate var photos: [Photo] = []
    fileprivate var page: Int = 1
    fileprivate var pages: Int = 1
    
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
    
    func removePhoto(_ photo: Photo) -> Int? {
        
        if let index = photos.index(of: photo) {
            
            photos.remove(at: index)
            
            moc.performChanges {
                
                self.moc.delete(photo)
            }
            
            return index
        }
        
        return nil
    }
    
    func hasPhotos() -> Bool {
        
        return pin.photos.count > 0
    }
    
    func photosCount() -> Int {
        
        return photos.count
    }
    
    func requestPhotos(_ completion: @escaping (Bool, String?) -> Void) {
        
        let flickrApi = FlickrAPI(urlPath: FlickrPath.ServicesRest)
        
        flickrApi.urlParameters = [
            "method": "flickr.photos.search" as AnyObject,
            "api_key": Constant.Flickr.apiKey as AnyObject,
            "lat": pin.latitude as AnyObject,
            "lon": pin.longitude as AnyObject,
            "extras": "url_q,url_m" as AnyObject,
            "format": "json" as AnyObject,
            "nojsoncallback": 1 as AnyObject,
            "content_type": 1 as AnyObject,
            "safe_search": 1 as AnyObject,
            "per_page": 24 as AnyObject,
            "page": page as AnyObject
        ]
        
        if page <= pages {
            page = page + 1
        } else {
            page = 1
        }
        
        connectionManager.httpRequest(requestAPI: flickrApi) { (response, success, errorMessage) in
            
            DispatchQueue.main.async(execute: { () -> Void in
                
                if success {
                    
                    if let data = response as? JSON, let results = data["photos"] as? JSON {
                        
                        if let pages = results["pages"] as? Int {
                            
                            self.pages = pages
                        }
                        
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
    
    func newCollection(_ completion: @escaping (Bool, String?) -> Void) {
        
        for photo in photos {
            
            removePhoto(photo)
        }
        
        requestPhotos { (success, errorMessage) in
            
            completion(success, errorMessage)
        }
    }
}

