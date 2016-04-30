//
//  Protocols.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation
import CoreData

protocol ManagedObjectContextSettable: class {
    
    var managedObjectContext: NSManagedObjectContext! { get set }
}
