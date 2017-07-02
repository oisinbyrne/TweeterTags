//
//  MentionsTVC.swift
//  TweeterTags
//
//  Created by Oisín Byrne on 26/03/2017.
//  Copyright © 2017 Computer Science. All rights reserved.
//

import UIKit

struct Section {
    var title : String
    var items : [CustomStringConvertible]
    
    init(title: String, items : [CustomStringConvertible]) {
        self.title = title
        self.items = items
    }
}

class MentionsTVC: UITableViewController {
    var sections: [Section] = []
    var tweet: TwitterTweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if !tweet.media.isEmpty {
            sections.append(Section(title: "Images", items: tweet.media))
        }
        if !tweet.urls.isEmpty {
            sections.append(Section(title: "URLs", items: tweet.urls))
        }
        if !tweet.hashtags.isEmpty{
            sections.append(Section(title: "Hashtags", items: tweet.hashtags))
        }
        if !tweet.userMentions.isEmpty {
            sections.append(Section(title: "Users", items: tweet.userMentions))
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        
        if section.title == "Images" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageTweetCell
            let media = section.items[indexPath.row] as! TwitterMedia
            let imageURL = media.url
            let aspectRatio = media.aspectRatio
            if let imageData = try? Data(contentsOf: imageURL) {
                cell.aspectRatio = aspectRatio
                cell.passedImage = UIImage(data: imageData)
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionCell", for: indexPath)
            let mentions = section.items[indexPath.row] as! TwitterMention
            cell.textLabel?.text = mentions.keyword
            
            return cell
        }
    }
}
