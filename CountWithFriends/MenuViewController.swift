//
//  MenuViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import GameKit

class MenuViewController: UIViewController, GCTurnBasedMatchHelperDelegate {
    var matchHelper : GCTurnBasedMatchHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        matchHelper = GCTurnBasedMatchHelper()
        matchHelper!.delegate = self 
        matchHelper!.authenticateLocalUser()
    }
    
    func attemptGameCenterLogin(loginView: UIViewController) {
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    
    func didJoinOrCreateMatch(match: GKTurnBasedMatch) {
        GKTurnBasedMatch.loadMatchesWithCompletionHandler { (matches: [GKTurnBasedMatch]?, error: NSError?) in
            if error != nil{
                print("Error in loading player's active matches: \(error)")
            }
            else{
                for match in matches!{
                    print("\nMatch participants:")
                    for participant in match.participants!{
                        print(participant.player?.displayName)
                    }
                }
                print(matches!.count)
            }
        }
    }
    
    @IBAction func onStartGameTapped(sender: AnyObject) {
//        GKTurnBasedMatch.loadMatchesWithCompletionHandler { (matches: [GKTurnBasedMatch]?, error: NSError?) in
//            for match in matches!{
//                match.removeWithCompletionHandler(nil)
//            }
//        }
        matchHelper?.joinOrStartRandomGame()
        performSegueWithIdentifier("startGameSegue", sender: sender)
    }

}
