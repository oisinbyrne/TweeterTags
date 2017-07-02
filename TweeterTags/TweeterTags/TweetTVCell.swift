//
//  TweetTVCell.swift
//  TweeterTags
//
//  Created by Oisín Byrne on 24/03/2017.
//  Copyright © 2017 Computer Science. All rights reserved.
//

import UIKit

class TweetTVCell: UITableViewCell {
    var tweet: TwitterTweet? {
        didSet {
            showTweet()
        }
    }
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    func showTweet() {
        if let tweet = self.tweet {
            if let imageURL = tweet.user.profileImageURL {
                if let imageData = try? Data(contentsOf: imageURL) {
                    profilePicture.image = UIImage(data: imageData)
                }
            }
            
            screenName?.text = "\(tweet.user)"
            
            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweet.created as Date) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            date?.text = formatter.string(from: tweet.created as Date)
            
            if tweetText?.text != nil  {
                let attributedString = NSMutableAttributedString(string: tweet.text)
                for hashtag in tweet.hashtags {
                    let range = hashtag.nsrange
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: range)
                }
                for url in tweet.urls {
                    let range = url.nsrange
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: range)
                }
                for mention in tweet.userMentions {
                    let range = mention.nsrange
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.green, range: range)
                }
                tweetText?.attributedText = attributedString
            }
        } else {
            return
        }
    }
}
