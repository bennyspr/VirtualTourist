//
//  ManagedObjectType.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//
//  Reference Book: Core Data by Florian Kugler and Daniel Eggert.

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
    
    public static var sortedFetchRequest: NSFetchRequest<NSFetchRequestResult> {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension ManagedObjectType where Self: ManagedObject {
    
    public static func findOrCreateInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: (Self) -> ()) -> Self {
        
        guard let obj = findOrFetchInContext(moc, matchingPredicate: predicate) else {
            
            let newObject: Self = moc.insertObject()
            configure(newObject)
            return newObject
        }
        
        return obj
    }
    
    public static func findOrFetchInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        
        guard let obj = materializedObjectInContext(moc, matchingPredicate: predicate) else {
            
            return fetchInContext(moc) { request in
                
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        
        return obj
    }
    
    public static func materializedObjectInContext(_ moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        
        for obj in moc.registeredObjects where !obj.isFault {
            
            guard let res = obj as? Self, predicate.evaluate(with: res) else {
                
                continue
            }
            
            return res
        }
        
        return nil
    }
    
    public static func fetchInContext(_ context: NSManagedObjectContext, configurationBlock: (NSFetchRequest<NSFetchRequestResult>) -> () = { _ in }) -> [Self] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Self.entityName)
        
        configurationBlock(request)
        
        guard let result = try! context.fetch(request) as? [Self] else {
            
            fatalError("Fetched objects have wrong type")
        }
        
        return result
    }
    
    
}


