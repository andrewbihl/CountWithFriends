//
//  MenuViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import GameKit

class MenuViewController: UIViewController, GCTurnBasedMatchHelperDelegate, UITableViewDelegate, UITableViewDataSource, GKLocalPlayerListener {
    @IBOutlet weak var tableView: UITableView!
    var matchHelper : GCTurnBasedMatchHelper?
    var matchToBeEntered: GKTurnBasedMatch?
    var yourTurnMatches = Array<(matchID: String, opponentDisplayName: String)>()
    var theirTurnMatches = Array<(matchID: String, opponentDisplayName: String)>()
    var currentlyReloadingGames = false

    override func viewDidLoad() {
        super.viewDidLoad()
        matchHelper = GCTurnBasedMatchHelper.sharedInstance
        matchHelper!.delegate = self
        matchHelper!.authenticateLocalUser()
    }
    override func viewDidAppear(animated: Bool) {
        GCTurnBasedMatchHelper.sharedInstance.loadExistingMatches()
    }
    
    func player(player: GKPlayer, receivedTurnEventForMatch match: GKTurnBasedMatch, didBecomeActive: Bool) {
        if match.currentParticipant?.playerID == GKLocalPlayer.localPlayer().playerID{
            print("Match knows that it is YOUR TURN.")
        } else{
            print("The match thinks it is still the other guys turn.")
        }
       // let newMatchID = match.matchID!
        //Sometimes the event gets sent twice. We don't want to re-update on repeated events.
//        if currentlyReloadingGames{
//            return
//        }
//        currentlyReloadingGames = true
        var newOpponentName = ""
        for participant in match.participants!{
            if participant.playerID != player.playerID{
                newOpponentName = participant.player!.displayName!
            }
        }
        newOpponentName = newOpponentName.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\u{200e}\u{200e}\u{201c}\u{201d}\u{202a}\u{202c}"))
        //should be yourMatches array in actual menu view controller
        //existingMatches.append((matchID: newMatchID, opponentDisplayName: newOpponentName))
        //TODO: UPDATE OPPONENT'S NAME FOR CASE of change from "Waiting for other player to join" -> Name
        for i in 0..<theirTurnMatches.count{
            var existingMatch = theirTurnMatches[i]
            if existingMatch.matchID == match.matchID{
                theirTurnMatches.removeAtIndex(i)
                existingMatch.opponentDisplayName = newOpponentName
                yourTurnMatches.append(existingMatch)
                self.tableView.reloadData()
                return
            }
        }
    }
    
    func didPassTurn() {
        GCTurnBasedMatchHelper.sharedInstance.loadExistingMatches()
    }
    
    func attemptGameCenterLogin(loginView: UIViewController) {
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    
    func didJoinOrCreateMatch(match: GKTurnBasedMatch) {
        matchToBeEntered = match
        self.performSegueWithIdentifier("startGameSegue", sender: nil)
    }
    
    func didLoadExistingMatches(yourTurnMatches: Array<(matchID: String,opponentDisplayName: String)>, theirTurnMatches: Array<(matchID: String,opponentDisplayName: String)>) {
        self.yourTurnMatches = yourTurnMatches
        self.theirTurnMatches = theirTurnMatches
        self.tableView.reloadData()
        currentlyReloadingGames = false
    }
    
    func didLoginToGameCenter() {
        matchHelper?.loadExistingMatches()
        GKLocalPlayer.localPlayer().registerListener(self)
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
            let dvc = segue.destinationViewController as! RoundMessageViewController
            dvc.localPlayerIsPlayer0 = localPlayerIsPlayer0
            dvc.opponentID = opponentID
            dvc.matchToBeEntered = matchToBeEntered
            //Moved Code to RoundMessageViewController
            
//            let newRoundHandler = RoundHandler()
//            newRoundHandler.myMatchData = matchToBeEntered?.matchData
//            newRoundHandler.localPlayerIsPlayer0 = localPlayerIsPlayer0
//            newRoundHandler.opponentDisplayName = opponentID
//            
//            let outcome = matchToBeEntered?.participants![0].matchOutcome
//            
//            let dvc = segue.destinationViewController as! RoundMessageViewController
//            dvc.myRoundHandler = newRoundHandler
//            if outcome != GKTurnBasedMatchOutcome.None{
//                dvc.gameIsFinished = true
//            }
//            else{
//                newRoundHandler.startNewRound(6)
//            }
        }
    }
    
    func deleteUsersMatches(){
        GKTurnBasedMatch.loadMatchesWithCompletionHandler { (matches: [GKTurnBasedMatch]?, error: NSError?) in
            if matches == nil{
                print("No existing matches")
                self.matchHelper?.loadExistingMatches()
            }else{
                for match in matches!{
                    match.removeWithCompletionHandler(nil)
                }
            }
        }
    }
    
    @IBAction func onDeleteGame(sender: AnyObject) {
        deleteUsersMatches()
    }
    
    @IBAction func onStartGameTapped(sender: AnyObject) {
        matchHelper?.joinOrStartRandomGame()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            matchHelper?.resumeGame(yourTurnMatches[indexPath.row].matchID)
        }
        else{
            print("Dude it's not your turn.")
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Your Turn"
        } else{
            return "Their Turn"
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return yourTurnMatches.count
        } else{
            return theirTurnMatches.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("matchCell")
        if indexPath.section == 0{
            cell?.textLabel?.text = yourTurnMatches[indexPath.row].opponentDisplayName
        }
        else{
            cell?.textLabel?.text = theirTurnMatches[indexPath.row].opponentDisplayName
        }
        return cell!
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) { }
    
}
