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
    
    public static var sortedFetchRequest: NSFetchRequest {
        
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension ManagedObjectType where Self: ManagedObject {
    
    public static func findOrCreateInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate, configure: Self -> ()) -> Self {
        
        guard let obj = findOrFetchInContext(moc, matchingPredicate: predicate) else {
            
            let newObject: Self = moc.insertObject()
            configure(newObject)
            return newObject
        }
        
        return obj
    }
    
    public static func findOrFetchInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        
        guard let obj = materializedObjectInContext(moc, matchingPredicate: predicate) else {
            
            return fetchInContext(moc) { request in
                
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        
        return obj
    }
    
    public static func materializedObjectInContext(moc: NSManagedObjectContext, matchingPredicate predicate: NSPredicate) -> Self? {
        
        for obj in moc.registeredObjects where !obj.fault {
            
            guard let res = obj as? Self where predicate.evaluateWithObject(res) else {
                
                continue
            }
            
            return res
        }
        
        return nil
    }
    
    public static func fetchInContext(context: NSManagedObjectContext, @noescape configurationBlock: NSFetchRequest -> () = { _ in }) -> [Self] {
        
        let request = NSFetchRequest(entityName: Self.entityName)
        
        configurationBlock(request)
        
        guard let result = try! context.executeFetchRequest(request) as? [Self] else {
            
            fatalError("Fetched objects have wrong type")
        }
        
        return result
    }
    
    
}


