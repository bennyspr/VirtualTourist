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
            } else {
                region.center.latitude = 17.895273380028243
            }
            
            if let key = defaults.objectForKey(UserDefaultKey.LongitudeDegree.rawValue) as? Double {
                region.center.longitude = key
            } else {
                region.center.longitude = -66.147898432380302
            }
            
            if let key = defaults.objectForKey(UserDefaultKey.LatitudeDelta.rawValue) as? Double {
                region.span.latitudeDelta = key
            } else {
                region.span.latitudeDelta = 7.3507605481962717
            }
            
            if let key = defaults.objectForKey(UserDefaultKey.LongitudeDelta.rawValue) as? Double {
                region.span.longitudeDelta = key
            } else {
                region.span.longitudeDelta = 4.8067309116039638
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