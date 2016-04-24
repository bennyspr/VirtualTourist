//
//  PhotoAlbumCell.swift
//  VirtualTourist
//
//  Created by Benny on 4/23/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit

class PhotoAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print(">>>>")
    }
    
    func configureWithData(data: JSON) {
        
        let url = NSURL(string: data["url_q"] as! String)
        
        dispatch_async(dispatch_queue_create(Constant.Queue.download, nil)) {
            
            let data = NSData(contentsOfURL: url!)
            
            let image = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                self.imageView.image = image
            })
        }
    }
}
