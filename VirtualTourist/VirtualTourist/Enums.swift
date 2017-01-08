//
//  Enums.swift
//  VirtualTourist
//
//  Created by Benny on 4/3/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import Foundation

enum HTTPRequestMethod: String {
    
    case GET, POST, PUT, DELETE
}

enum FlickrPath: String {
    
    case None = ""
    case ServicesRest = "services/rest/"
}

enum UserDefaultKey: String {
    
    case LatitudeDegree
    case LongitudeDegree
    case LatitudeDelta
    case LongitudeDelta
}

enum StatusButton: String {
    
    case Edit
    case Done
}

enum DataProviderUpdate<Object> {
    case insert(IndexPath)
    case update(IndexPath, Object)
    case move(IndexPath, IndexPath)
    case delete(IndexPath)
}

enum CollectionStatusButton: String {
    
    case Remove
    case New
}
