//
//  JokeCellTableViewCell.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import Firebase

class JokeCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jokeText: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var totalVotesLabel: UILabel!
    @IBOutlet weak var thumbVoteImage: UIImageView!
    var joke: Joke!
    var voteRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // UITapGestureRecognizer
        
        let tap = UITapGestureRecognizer(target: self, action: "voteTapped:")
        tap.numberOfTapsRequired = 1
        thumbVoteImage.addGestureRecognizer(tap)
        thumbVoteImage.userInteractionEnabled = true
    }
    
    func configureCell(joke: Joke) {
        self.joke = joke
        
        // Set the labesl and textView
        jokeText.text = joke.jokeText
        totalVotesLabel.text = "Total votes: \(joke.jokeVotes)"
        usernameLabel.text = joke.username
        
        //Set votes as a child of the current user in Firebase and save the joke's key in votes as a boolean
        voteRef = DataService.dataService.CURRENT_USER_REF.childByAppendingPath("votes").childByAppendingPath(joke.jokeKey)
        
        //observeSingleEventOfType() listens for the thumb to be tapped, by any user, on any device
        voteRef.observeEventType(.Value, withBlock: { snapshot in
            
            // Set the thumb image
            if let thumbsUpDown = snapshot.value as? NSNull {
                //Current user hasn't voted for the joke...yet
                
                print(thumbsUpDown)
            } else {
                // Current user voted for the joke!
                self.thumbVoteImage.image = UIImage(named: "thumb-up")
            }
        })
    
        
    }
    
    func voteTapped(sender: UITapGestureRecognizer) {
        
        //observeSingleEventOfType listens for a tap by the current user/
        
        voteRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
        
            if let thumbsUpDown = snapshot.value as? NSNull {
                print(thumbsUpDown)
                self.thumbVoteImage.image = UIImage(named: "thumb-down")
                
                //addSubtractVote(), in Joke.swift handles the vote
                
                self.joke.addSubtractVote(true)
            } else {
                self.thumbVoteImage.image = UIImage(named: "thumb-up")
                self.joke.addSubtractVote(false)
                self.voteRef.removeValue()
            }
        
        
        
        })
    }
    
}
