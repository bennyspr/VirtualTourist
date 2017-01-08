//
//  NSManagedObjectContext+Custom.swift
//  VirtualTourist
//
//  Created by Benny on 5/1/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//
//  Reference Book: Core Data by Florian Kugler and Daniel Eggert.

import CoreData

extension NSManagedObjectContext {
    
    public func insertObject<A: ManagedObject> () -> A where A: ManagedObjectType {
        
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            
            fatalError("Wrong object type")
        }
        
        return obj
    }
    
    public func saveOrRollback() -> Bool {
        
        do {
            try save()
            return true
            
        } catch {
            
            rollback()
            return false
        }
    }
    
    public func performChanges(_ block: @escaping () -> ()) {
        
        perform {
            block()
            self.saveOrRollback()
        }
    }
}
