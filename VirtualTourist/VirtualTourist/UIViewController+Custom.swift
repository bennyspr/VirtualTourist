//
//  UIViewController+Custom.swift
//  VirtualTourist
//
//  Created by Benny on 5/29/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlertView(withTitle title: String? = nil, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
