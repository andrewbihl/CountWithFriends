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

class CenterViewController: UIViewController, GCTurnBasedMatchHelperDelegate,UICollectionViewDataSource, UICollectionViewDelegate, GKLocalPlayerListener, UICollectionViewDelegateFlowLayout, GKTurnBasedEventListener {
    @IBOutlet var menuButton: UIButton!
    var matchHelper : GCTurnBasedMatchHelper?
    var matchToBeEntered: GKTurnBasedMatch?
    var yourTurnMatches = Array<(matchID: String, opponentDisplayName: String)>()
    var theirTurnMatches = Array<(matchID: String, opponentDisplayName: String)>()
    
    private let cellID = "Cell"
    
    var delegate: CenterViewControllerDelegate?
    
    @IBOutlet var yourTurnCollectionView: YourTurnCollectionView!
    @IBOutlet var theirTurnCollectionView: TheirTurnCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchHelper = GCTurnBasedMatchHelper.sharedInstance
        matchHelper!.delegate = self
        matchHelper!.authenticateLocalUser()
        menuButton.setImage(defaultMenuImage(), forState: .Normal)
        
//        yourTurnMatches = [(matchID:"Friend", opponentDisplayName:"Opponent")]
    }
    
    override func viewWillAppear(animated:
        Bool) {
        super.viewWillAppear(animated)
        GCTurnBasedMatchHelper.sharedInstance.loadExistingMatches()
    }

    
    @IBAction func onProfilePressed(sender: AnyObject) {
        
        delegate?.toggleRightPanel()
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//      if collectionView == yourTurnCollectionView
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("matchCell", forIndexPath: indexPath)
            as! GameCollectionViewCell
        if collectionView.restorationIdentifier == "yourTurnMatchesCollection"{
            cell.label.text = yourTurnMatches[indexPath.item].opponentDisplayName
        }
        else{
            cell.label.text = theirTurnMatches[indexPath.item].opponentDisplayName
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.restorationIdentifier == "yourTurnMatchesCollection"{
            return yourTurnMatches.count
        }
        else{
            return theirTurnMatches.count
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.restorationIdentifier == "yourTurnMatchesCollection"{
            matchHelper?.resumeGame(yourTurnMatches[indexPath.item].matchID)
        }
        else{
            matchHelper?.resumeGame(theirTurnMatches[indexPath.item].matchID)
        }
    }
    
    
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
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
    
    func didLoadExistingMatches(yourTurnMatches: Array<(matchID: String,opponentDisplayName: String)>, theirTurnMatches: Array<(matchID: String,opponentDisplayName: String)>) {
        self.yourTurnMatches = yourTurnMatches
        self.theirTurnMatches = theirTurnMatches
        yourTurnCollectionView.reloadData()
        theirTurnCollectionView.reloadData()
        // self.collectionView.
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
    
    
    func didPassTurn() {
        
    }
    
    
    
}





