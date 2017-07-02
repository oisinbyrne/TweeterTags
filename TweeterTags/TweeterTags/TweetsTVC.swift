//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Oisín Byrne on 23/03/2017.
//  Copyright © 2017 Computer Science. All rights reserved.
//

import UIKit

class TweetsTVC: UITableViewController, UITextFieldDelegate {
    private var tweets = [[TwitterTweet]]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var twitterRequest: TwitterRequest?
    private var twitterQueryText: String? = "#ucd" {
        didSet {
            twitterQueryTextField?.text = twitterQueryText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }

    private func refresh() {
        let request = TwitterRequest(search: twitterQueryText!, count: 20)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            request.fetchTweets { (newTweets) -> Void in
                if newTweets.count > 0 {
                    self.twitterRequest = request
                    DispatchQueue.main.async { () -> Void in
                        self.tweets.insert(newTweets, at: 0)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }

    
    // MARK: - Delegate Methods
    
    @IBOutlet weak var twitterQueryTextField: UITextField! {
        didSet {
            twitterQueryTextField.delegate = self
            twitterQueryTextField.text = twitterQueryText
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        twitterQueryText = textField.text
        return true
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TweetTVCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = tableView.indexPathForSelectedRow!
        let cell = tableView.cellForRow(at: index) as! TweetTVCell
        if(segue.identifier == "ViewTweetMentions") {
            let mentionsVC = segue.destination as! MentionsTVC
            mentionsVC.tweet = cell.tweet
        }
    }
}
