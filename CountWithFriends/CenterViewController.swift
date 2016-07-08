//
//  CenterViewController.swift
//  CountWithFriends
//
//  Created by joy on 6/29/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import GameKit
import UIKit

protocol CenterViewControllerDelegate {
     func toggleRightPanel()
}

class CenterViewController: UIViewController, UICollectionViewDelegateFlowLayout, GCTurnBasedMatchHelperDelegate, UITableViewDelegate, UITableViewDataSource, GKTurnBasedEventListener {
    @IBOutlet weak var tableView: UITableView!
    var matchHelper : GCTurnBasedMatchHelper?
    var matchToBeEntered: GKTurnBasedMatch?
    var existingMatches = Array<(matchID: String, opponentDisplayName: String)>()
    
    private let cellID = "cellID"
    
    var delegate: CenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // collectionView?.registerClass(CategoryCell.self, forCellWithReuseIdentifier: cellID)
        
        // collectionView?.backgroundColor = UIColor.yellowColor()
        
        menuButton.setImage(defaultMenuImage(), forState: .Normal)
        
    }
    
    @IBOutlet var menuButton: UIButton!
    
    
    
    @IBAction func onProfilePressed(sender: AnyObject) {
        
        delegate?.toggleRightPanel()
    }
    
    
    
    // override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    //        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! CategoryCell
    //
    //        return cell
    //    }
    
    
    //    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //
    //        return 2
    //
    //    }
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //
    //
    //
    //        return CGSizeMake(view.frame.width - 40, 50)
    //    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 22), false, 0.0)
        
        UIColor.blackColor().setFill()
        UIBezierPath(rect: CGRectMake(0, 3, 30, 1)).fill()
        UIBezierPath(rect: CGRectMake(0, 10, 30, 1)).fill()
        UIBezierPath(rect: CGRectMake(0, 17, 30, 1)).fill()
        
        UIColor.whiteColor().setFill()
        UIBezierPath(rect: CGRectMake(0, 4, 30, 1)).fill()
        UIBezierPath(rect: CGRectMake(0, 11,  30, 1)).fill()
        UIBezierPath(rect: CGRectMake(0, 18, 30, 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchHelper = GCTurnBasedMatchHelper.sharedInstance
        matchHelper!.delegate = self
        matchHelper!.authenticateLocalUser()
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func player(player: GKPlayer, receivedTurnEventForMatch match: GKTurnBasedMatch, didBecomeActive: Bool) {
        print("It's YOUR TURN!!!!!!!!")
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





