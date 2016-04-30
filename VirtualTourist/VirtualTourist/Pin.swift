//
//  Pin.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation
import CoreData

public final class Pin: ManagedObject {
    
    @NSManaged public private(set) var latitude: Double
    @NSManaged public private(set) var longitude: Double
}
