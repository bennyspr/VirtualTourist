//
//  Photo.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation
import CoreData

public final class Photo: ManagedObject {
    
    @NSManaged public private(set) var id: Int
    @NSManaged public private(set) var path: String
    @NSManaged public private(set) var url_m: String
    @NSManaged public private(set) var url_q: String
}
