//
//  Photo.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation
import CoreData

@objc(Photo)
public final class Photo: ManagedObject {
    
    @NSManaged public private(set) var id: Int
    @NSManaged public private(set) var path: String
    @NSManaged public private(set) var url_m: String
    @NSManaged public private(set) var url_q: String
    @NSManaged public private(set) var pin: Pin
    
    public static func insertIntoContext(moc: NSManagedObjectContext, data: NSDictionary, pin: Pin) -> Photo {
        
        let photo: Photo = moc.insertObject()
        photo.id = data["id"] as! Int
        photo.path = data["path"] as! String
        photo.url_m = data["url_m"] as! String
        photo.url_q = data["url_q"] as! String
        photo.pin = pin
        return photo
    }
    
    public static func findOrCreatePhotoForPin(pin: Pin, inContext moc: NSManagedObjectContext, data: NSDictionary) -> Photo {
     
        let predicate = NSPredicate(format: "%K == %d", "id", data["id"] as! Int)
        
        let photo = findOrCreateInContext(moc, matchingPredicate: predicate) { (newPhoto) in
            
            newPhoto.id = data["id"] as! Int
            newPhoto.path = data["path"] as! String
            newPhoto.url_m = data["url_m"] as! String
            newPhoto.url_q = data["url_q"] as! String
            newPhoto.pin = pin
        }
        
        return photo
    }
}

// MARK: ManagedObjectType
extension Photo: ManagedObjectType {
    
    public static var entityName: String {
        
        return "Photo"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        
        return [
            // NSSortDescriptor(key: "date", ascending: false)
        ]
    }
}

