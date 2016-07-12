//
//  RoundMessageViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 7/10/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import GameKit

class RoundMessageViewController: UIViewController {
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var player0Label: UILabel!
    @IBOutlet weak var player0ScoreLabel: UILabel!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var beginMatchButton: UIButton!
    
    
    var matchToBeEntered: GKTurnBasedMatch?
    var gameIsFinished = false
    var opponentID: String?
    var localPlayerIsPlayer0 = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player0Label.text = GKLocalPlayer.localPlayer().alias
        player0ScoreLabel.text = "Score: 0"
        if let opponent = matchToBeEntered?.participants![1].player?.displayName {
            player1Label.text = opponent
        } else {
            player1Label.text = "New Opponent"
            roundLabel.text = "New Game"
            beginMatchButton.setTitle("Start New Game", forState: .Normal)
        }
        player1ScoreLabel.text = "Score: 0"
        
        

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let newRoundHandler = RoundHandler()
        newRoundHandler.myMatchData = matchToBeEntered?.matchData
        newRoundHandler.localPlayerIsPlayer0 = localPlayerIsPlayer0
        newRoundHandler.opponentDisplayName = opponentID
        
        let outcome = matchToBeEntered?.participants![0].matchOutcome
        
        let dvc = segue.destinationViewController as! GameBoardViewController
        dvc.myRoundHandler = newRoundHandler
        if outcome != GKTurnBasedMatchOutcome.None{
            dvc.gameIsFinished = true
        }
        else{
            newRoundHandler.startNewRound(6)
        }
    }
    @IBAction func onBackButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
