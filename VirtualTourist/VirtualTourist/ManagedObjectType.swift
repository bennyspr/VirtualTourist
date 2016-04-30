//
//  ManagedObjectType.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation
import CoreData

public protocol ManagedObjectType: class {
    
    static var entityName: String { get }
    
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}

extension ManagedObjectType {
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest {
        
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}