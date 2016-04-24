//
//  EditBarButton.swift
//  VirtualTourist
//
//  Created by Benny on 4/23/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit

class EditBarButton: UIBarButtonItem {

    var status: StatusButton = StatusButton.Edit {
        
        didSet {
            self.title = status.rawValue
        }
    }
 
    
}
