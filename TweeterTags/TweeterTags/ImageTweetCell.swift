//
//  ImageTweetCell.swift
//  TweeterTags
//
//  Created by Oisín on 01/04/2017.
//  Copyright © 2017 Computer Science. All rights reserved.
//

import UIKit

class ImageTweetCell: UITableViewCell {
    var passedImage: UIImage? {
        didSet {
            showCell()
        }
    }
    var aspectRatio: Double?
    @IBOutlet weak var tweetImage: UIImageView!
    
    func showCell() {
        if let image = self.passedImage {
            tweetImage.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width / CGFloat(aspectRatio!))
            tweetImage.image = image
            tweetImage.contentMode = UIViewContentMode.scaleAspectFit
        }
    }
}
