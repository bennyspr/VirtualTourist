//
//  PhotoAlbumCell.swift
//  VirtualTourist
//
//  Created by Benny on 4/23/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//

import UIKit
import CoreData

class PhotoAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                self.imageView.alpha = 0.5
            } else if newValue == false {
                super.selected = false
                self.imageView.alpha = 1.0
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func configureWithPhoto(photo: Photo, inContext moc: NSManagedObjectContext) {
        
        if let data = photo.data {
            
            imageView.image = UIImage(data: data)
            layoutIfNeeded()
            
        } else {
            
            let gifUrl = NSBundle.mainBundle().URLForResource("loading_spinner", withExtension: "gif")
            let gifImage = UIImage.animatedImageWithAnimatedGIFData(NSData(contentsOfURL: gifUrl!)!)
            
            imageView.animationImages = gifImage?.images
            imageView.animationDuration = (gifImage?.duration)!
            imageView.image = gifImage?.images![(gifImage?.images?.count)! - 1]
            layoutIfNeeded()
            imageView.startAnimating()
            
            let url = NSURL(string: photo.url_q)
            
            dispatch_async(dispatch_queue_create(Constant.Queue.download, nil)) {
                
                let data = NSData(contentsOfURL: url!)
                
                Photo.setImageDataForPhoto(photo, inContext: moc, data: data!)
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.imageView.stopAnimating()
                    self.imageView.image = UIImage(data: data!)
                })
            }
        }
        
    }
}
