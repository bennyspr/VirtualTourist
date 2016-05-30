//
//  Photo.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import CoreData

@objc(Photo)
public final class Photo: ManagedObject {
    
    @NSManaged public private(set) var id: String
    @NSManaged public private(set) var data: NSData?
    @NSManaged public private(set) var url_m: String
    @NSManaged public private(set) var url_q: String
    @NSManaged public private(set) var pin: Pin
    
    public static func insertIntoContext(moc: NSManagedObjectContext, data: NSDictionary, pin: Pin) -> Photo {
        
        let photo: Photo = moc.insertObject()
        photo.id = data["id"] as! String
        photo.url_m = data["url_m"] as! String
        photo.url_q = data["url_q"] as! String
        photo.pin = pin
        return photo
    }
    
    public static func findOrCreatePhotoForPin(pin: Pin, inContext moc: NSManagedObjectContext, data: NSDictionary) -> Photo {
     
        let id = data["id"] as! String
        let predicate = NSPredicate(format: "%K == %d", "id", id)
        
        let photo = findOrCreateInContext(moc, matchingPredicate: predicate) { (newPhoto) in
            
            newPhoto.id = id
            newPhoto.url_m = data["url_m"] as! String
            newPhoto.url_q = data["url_q"] as! String
            newPhoto.pin = pin
        }
        
        return photo
    }
    
    public static func setImageDataForPhoto(photo: Photo, inContext moc: NSManagedObjectContext, data: NSData) {
        
        moc.performChanges {
            
            photo.data = data
        }
    }
}

// MARK: ManagedObjectType
extension Photo: ManagedObjectType {
    
    public static var entityName: String {
        
        return "Photo"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        
        return [
            // NSSortDescriptor(key: "id", ascending: false)
        ]
    }
}

