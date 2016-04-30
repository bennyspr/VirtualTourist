//
//  MainViewController.swift
//  VirtualTourist
//
//  Created by Benny on 4/30/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, ManagedObjectContextSettable {

    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
    }

   

}
