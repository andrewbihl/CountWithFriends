//
//  MenuViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import GameKit

class MenuViewController: UIViewController, GCTurnBasedMatchHelperDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var matchHelper : GCTurnBasedMatchHelper?
    var matchToBeEntered: GKTurnBasedMatch?
    var existingMatches = Array<(matchID: String, opponentDisplayName: String)>()

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
        matchToBeEntered = match
        self.performSegueWithIdentifier("startGameSegue", sender: nil)
    }
    
    func didLoadExistingMatches(existingMatches: Array<(matchID: String, opponentDisplayName: String)>) {
        self.existingMatches = existingMatches
        self.tableView.reloadData()
    }
    
    func didLoginToGameCenter() {
        matchHelper?.loadExistingMatches()
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
            newRoundHandler.myMatchData = matchToBeEntered?.matchData
            newRoundHandler.localPlayerIsPlayer0 = localPlayerIsPlayer0
            newRoundHandler.opponentDisplayName = opponentID
            newRoundHandler.startNewRound(6)
            let dvc = segue.destinationViewController as! GameBoardViewController
            dvc.myRoundHandler = newRoundHandler
        }
    }
    
    func deleteUsersMatches(){
        GKTurnBasedMatch.loadMatchesWithCompletionHandler { (matches: [GKTurnBasedMatch]?, error: NSError?) in
            if matches == nil{
                print("No existing matches")
            }else{
                for match in matches!{
                    match.removeWithCompletionHandler(nil)
                }
            }
        }
    }
    
    @IBAction func onStartGameTapped(sender: AnyObject) {
//        deleteUsersMatches()
        matchHelper?.joinOrStartRandomGame()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        matchHelper?.resumeGame(existingMatches[indexPath.row].matchID)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return existingMatches.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("matchCell")
        cell?.textLabel?.text = existingMatches[indexPath.row].opponentDisplayName
        return cell!
    }
    
}
