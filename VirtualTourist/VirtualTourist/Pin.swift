//
//  Pin.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public final class Pin: ManagedObject {
    
    @NSManaged public private(set) var latitude: Double
    @NSManaged public private(set) var longitude: Double
    @NSManaged public private(set) var photos: Set<Photo>
    
    lazy var annotation: MKPointAnnotation = {
        
        let point = MKPointAnnotation()
        point.coordinate.longitude = self.longitude
        point.coordinate.latitude = self.latitude
        return point
    }()
    
    public static func insertIntoContext(moc: NSManagedObjectContext, latitude: Double, longitude: Double) -> Pin {
        
        let pin: Pin = moc.insertObject()
        pin.latitude = latitude
        pin.longitude = longitude
        return pin
    }
    
    
    
}

// MARK: ManagedObjectType
extension Pin: ManagedObjectType {
    
    public static var entityName: String {
        
        return "Pin"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        
        return [
            // NSSortDescriptor(key: "date", ascending: false)
        ]
    }
}
