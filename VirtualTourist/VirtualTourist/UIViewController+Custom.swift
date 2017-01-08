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
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
}
