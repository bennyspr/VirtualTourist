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
    
    var frc: NSFetchedResultsController<NSFetchRequestResult>!
    
    lazy var user: User = {
        return User.sharedInstance
    }()
    
    lazy var connectionManager: ConnectionManager = {
        
        return ConnectionManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
    }

   

}
