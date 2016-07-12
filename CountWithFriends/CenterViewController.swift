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

class CenterViewController: UIViewController, UICollectionViewDelegateFlowLayout, GCTurnBasedMatchHelperDelegate, GKTurnBasedEventListener, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet var menuButton: UIButton!
    var matchHelper : GCTurnBasedMatchHelper?
    var matchToBeEntered: GKTurnBasedMatch?
    //    var yourTurnMatchesController: YourTurnGamesCollectionViewController?
    //    var theirTurnMatchesController: TheirTurnGamesCollectionViewController?
    var yourTurnMatches = Array<(matchID: String, opponentDisplayName: String)>()
    var theirTurnMatches = Array<(matchID: String, opponentDisplayName: String)>()
    private let cellID = "Cell"
    
    var delegate: CenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchHelper = GCTurnBasedMatchHelper.sharedInstance
        matchHelper!.delegate = self
        matchHelper!.authenticateLocalUser()
        menuButton.setImage(defaultMenuImage(), forState: .Normal)
        //        yourTurnMatchesController = childViewControllers[0] as! YourTurnGamesCollectionViewController
        //        theirTurnMatchesController = childViewControllers[1] as! TheirTurnGamesCollectionViewController
    }
    
    
    
    
    @IBAction func onProfilePressed(sender: AnyObject) {
        
        delegate?.toggleRightPanel()
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! GameCollectionViewCell
        cell.label.text = "Placeholder text"
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
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
    
    func didLoadExistingMatches(yourTurnMatches: Array<(matchID: String, opponentDisplayName: String)>, theirTurnMatches: Array<(matchID: String, opponentDisplayName: String)>) {
        self.yourTurnMatches = yourTurnMatches
        self.theirTurnMatches = theirTurnMatches
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
}





