//
//  Joke.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import Foundation
import Firebase

class Joke {
    private(set) var jokeRef: Firebase!
    
    private(set) var jokeKey: String!
    private(set) var jokeText: String!
    private(set) var jokeVotes: Int!
    private(set) var username: String!
    
    init(key: String, dictionary: Dictionary<String, AnyObject>) {
        jokeKey = key
        
        // Within the Joke, or Key, the following properties are children
        
        if let votes = dictionary["votes"] as? Int {
            jokeVotes = votes
        }
        
        if let joke = dictionary["jokeText"] as? String {
            jokeText = joke
        }
        
        if let user = dictionary["author"] as? String {
            username = user
        } else {
            username = ""
        }
        
        jokeRef = DataService.dataService.JOKE_REF.childByAppendingPath(jokeKey)
    }
    
    func addSubtractVote(addVote: Bool) {
        
        if addVote {
            jokeVotes! += 1
        } else {
            jokeVotes! -= 1
        }
        
        //Save the new vote total
        jokeRef.childByAppendingPath("votes").setValue(jokeVotes)
    }
    
}

