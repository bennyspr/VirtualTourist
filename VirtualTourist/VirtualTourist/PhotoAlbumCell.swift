//
//  PhotoAlbumCell.swift
//  VirtualTourist
//
//  Created by Benny on 4/23/16.
//  Copyright © 2016 Benny Rodriguez. All rights reserved.
//
//  A UIImage category that loads animated GIFs.
//  https://github.com/mayoff/uiimage-from-animated-gif

import UIKit
import CoreData

class PhotoAlbumCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                self.imageView.alpha = 0.5
            } else if newValue == false {
                super.isSelected = false
                self.imageView.alpha = 1.0
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    func configureWithPhoto(_ photo: Photo, inContext moc: NSManagedObjectContext) {
        
        if let data = photo.data {
            
            imageView.image = UIImage(data: data as Data)
            layoutIfNeeded()
            
        } else {
            
            let gifUrl = Bundle.main.url(forResource: "loading_spinner", withExtension: "gif")
            let gifImage = UIImage.animatedImage(withAnimatedGIFData: try! Data(contentsOf: gifUrl!))
            
            imageView.animationImages = gifImage?.images
            imageView.animationDuration = (gifImage?.duration)!
            imageView.image = gifImage?.images![(gifImage?.images?.count)! - 1]
            layoutIfNeeded()
            imageView.startAnimating()
            
            let url = URL(string: photo.url_q)
            
            DispatchQueue(label: Constant.Queue.download, attributes: []).async {
                
                let data = try? Data(contentsOf: url!)
                
                Photo.setImageDataForPhoto(photo, inContext: moc, data: data!)
                
                DispatchQueue.main.async(execute: {
                    
                    self.imageView.stopAnimating()
                    self.imageView.image = UIImage(data: data!)
                })
            }
        }
        
    }
}
