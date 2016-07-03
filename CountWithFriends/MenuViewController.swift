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
    var matchToBeEntered: GKTurnBasedMatch?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        matchHelper = GCTurnBasedMatchHelper.sharedInstance
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
        matchToBeEntered = match
        self.performSegueWithIdentifier("startGameSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startGameSegue"{
            //Create new RoundHandler, set it to be property on GameBoardVC
            var localPlayerIsPlayer0 = false
            var opponentID: String?
            if matchToBeEntered?.currentParticipant == matchToBeEntered?.participants![0]{
                localPlayerIsPlayer0 = true
                opponentID = matchToBeEntered?.participants![1].player?.displayName
            }
            else{
                opponentID = matchToBeEntered?.participants![0].player?.displayName
            }
            if opponentID == nil{
                opponentID = "Opponent not yet found"
            }
            let newRoundHandler = RoundHandler()
            newRoundHandler.startNewRound(6)
            newRoundHandler.myMatchData = matchToBeEntered?.matchData
            newRoundHandler.localPlayerIsPlayer0 = localPlayerIsPlayer0
            newRoundHandler.opponentDisplayName = opponentID
            let dvc = segue.destinationViewController as! GameBoardViewController
            dvc.myRoundHandler = newRoundHandler
        }
    }
    
    @IBAction func onStartGameTapped(sender: AnyObject) {
//        GKTurnBasedMatch.loadMatchesWithCompletionHandler { (matches: [GKTurnBasedMatch]?, error: NSError?) in
//            for match in matches!{
//                match.removeWithCompletionHandler(nil)
//            }
//        }
        matchHelper?.joinOrStartRandomGame()
    }

}
