//
//  VirtualTourist.swift
//  VirtualTourist
//
//  Created by Benny on 4/3/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit

class VirtualTouristHelper: NSObject {
    
    // MARK: Escape HTML Parameters
    class func escapedParameters(_ parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joined(separator: "&")
    }
    
}
