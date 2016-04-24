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

public class User {
    
    class var sharedInstance: User {
        
        struct Singleton {
            
            static let instance = User()
        }
        
        return Singleton.instance
    }
    
    private lazy var defaults = {
        
       return NSUserDefaults.standardUserDefaults()
    }()
    
    var previousRegion: MKCoordinateRegion {
        
        get {
            
            var region = MKCoordinateRegion()
            
            if let key = defaults.objectForKey(UserDefaultKey.LatitudeDegree.rawValue) as? Double {
                region.center.latitude = key
            }
            
            if let key = defaults.objectForKey(UserDefaultKey.LongitudeDegree.rawValue) as? Double {
                region.center.longitude = key
            }
            
            if let key = defaults.objectForKey(UserDefaultKey.LatitudeDelta.rawValue) as? Double {
                region.span.latitudeDelta = key
            }
            
            if let key = defaults.objectForKey(UserDefaultKey.LongitudeDelta.rawValue) as? Double {
                region.span.longitudeDelta = key
            }
            
            return region
        }
        set(region) {
    
            defaults.setDouble(region.center.latitude, forKey: UserDefaultKey.LatitudeDegree.rawValue)
            defaults.setDouble(region.center.longitude, forKey: UserDefaultKey.LongitudeDegree.rawValue)
            defaults.setDouble(region.span.latitudeDelta, forKey: UserDefaultKey.LatitudeDelta.rawValue)
            defaults.setDouble(region.span.longitudeDelta, forKey: UserDefaultKey.LongitudeDelta.rawValue)
        }
        
    }
    
    
    
    private init() {
        
    }
    
    public func save() {
        
        
    }
}