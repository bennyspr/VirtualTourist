//
//  User.swift
//  VirtualTourist
//
//  Created by Benny on 4/16/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//
// Using Singletons
// http://www.wadecantley.com/lifeblog/2014/11/25/global-variables-singletons-in-swift

import UIKit
import MapKit

open class User {
    
    class var sharedInstance: User {
        
        struct Singleton {
            
            static let instance = User()
        }
        
        return Singleton.instance
    }
    
    fileprivate lazy var defaults = {
        
       return UserDefaults.standard
    }()
    
    var previousRegion: MKCoordinateRegion {
        
        get {
            
            var region = MKCoordinateRegion()
            
            if let key = defaults.object(forKey: UserDefaultKey.LatitudeDegree.rawValue) as? Double {
                region.center.latitude = key
            } else {
                region.center.latitude = 17.89
            }
            
            if let key = defaults.object(forKey: UserDefaultKey.LongitudeDegree.rawValue) as? Double {
                region.center.longitude = key
            } else {
                region.center.longitude = -66.14
            }
            
            if let key = defaults.object(forKey: UserDefaultKey.LatitudeDelta.rawValue) as? Double {
                region.span.latitudeDelta = key
            } else {
                region.span.latitudeDelta = 7.35
            }
            
            if let key = defaults.object(forKey: UserDefaultKey.LongitudeDelta.rawValue) as? Double {
                region.span.longitudeDelta = key
            } else {
                region.span.longitudeDelta = 4.80
            }
            
            return region
        }
        set(region) {
    
            defaults.set(region.center.latitude, forKey: UserDefaultKey.LatitudeDegree.rawValue)
            defaults.set(region.center.longitude, forKey: UserDefaultKey.LongitudeDegree.rawValue)
            defaults.set(region.span.latitudeDelta, forKey: UserDefaultKey.LatitudeDelta.rawValue)
            defaults.set(region.span.longitudeDelta, forKey: UserDefaultKey.LongitudeDelta.rawValue)
        }
        
    }
    
    
    
    fileprivate init() {
        
    }
    
    open func save() {
        
        
    }
}
