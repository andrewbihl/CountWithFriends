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

class CenterViewController: UIViewController, GCTurnBasedMatchHelperDelegate,UICollectionViewDataSource, UICollectionViewDelegate, GKLocalPlayerListener, UICollectionViewDelegateFlowLayout {
    @IBOutlet var menuButton: UIButton!
    @IBOutlet var yourTurnCollectionView: YourTurnCollectionView!
    @IBOutlet var theirTurnCollectionView: YourTurnCollectionView!
    var matchHelper : GCTurnBasedMatchHelper?
    var matchToBeEntered: GKTurnBasedMatch?
    var yourTurnMatches = Array<(matchID: String, opponentDisplayName: String)>()
    var theirTurnMatches = Array<(matchID: String, opponentDisplayName: String)>()
    var currentlyReloadingGames = false
    let gradient = CAGradientLayer()
    var delegate: CenterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchHelper = GCTurnBasedMatchHelper.sharedInstance
        matchHelper!.delegate = self
        self.view.backgroundColor = UIColor.sunsetOverlay()
        menuButton.setImage(defaultMenuImage(), forState: .Normal)
        addGradiant(UIColor.sunsetLight(), bottomColor: UIColor.sunsetDark())
        
        matchHelper!.authenticateLocalUser()
        
        //        yourTurnMatches = [(matchID:"Friend", opponentDisplayName:"Opponent")]
    }
    
    override func viewWillAppear(animated:
        Bool) {
        super.viewWillAppear(animated)
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
                self.yourTurnCollectionView.reloadData()
                self.theirTurnCollectionView.reloadData()
                self.yourTurnCollectionView.reloadInputViews()
                self.theirTurnCollectionView.reloadInputViews()
                return
            }
        }
        
    }

    
    func didPassTurn() {
        GCTurnBasedMatchHelper.sharedInstance.loadExistingMatches()
    }
    
    private func addGradiant(topColor: UIColor, bottomColor: UIColor) {
        let colorArray:[CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let locations:[Int] = [0,1]
        gradient.colors = colorArray
        gradient.frame = self.view.frame
        gradient.locations = locations
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
//    override func viewWillAppear(animated:
//        Bool) {
//        super.viewWillAppear(animated)
//        GCTurnBasedMatchHelper.sharedInstance.loadExistingMatches()
//    }

    
    @IBAction func onProfilePressed(sender: AnyObject) {
        delegate?.toggleRightPanel()
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//      if collectionView == yourTurnCollectionView
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("matchCell", forIndexPath: indexPath)
            as! GameCollectionViewCell
        if collectionView == yourTurnCollectionView{
            cell.label.text = yourTurnMatches[indexPath.item].opponentDisplayName
        }
        else{
            cell.label.text = theirTurnMatches[indexPath.item].opponentDisplayName
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == yourTurnCollectionView{
            return yourTurnMatches.count
        }
        else{
            return theirTurnMatches.count
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == yourTurnCollectionView{
            matchHelper?.resumeGame(yourTurnMatches[indexPath.item].matchID)
        }
        else{
            
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
    
    
    func attemptGameCenterLogin(loginView: UIViewController) {
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    
    func didJoinOrCreateMatch(match: GKTurnBasedMatch?, error : NSError?) {
        if error != nil{
            presentOfflineAlert("User Offline")
        } else{
            matchToBeEntered = match!
            if matchToBeEntered?.matchData == nil {
                presentOfflineAlert("Failed to Load Match")
            }else{
                self.performSegueWithIdentifier("startGameSegue", sender: nil)
            }
        }
    }
    
    func presentOfflineAlert(title:String){
        let offlineAlert = UIAlertController(title: title, message: "Sorry, this game cannot be played offline. Please check your internet connection and try again.", preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Cancel, handler: nil)
        offlineAlert.addAction(okayAction)
        self.presentViewController(offlineAlert, animated: true, completion: nil)
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
//            let newRoundHandler = RoundHandler()
//            newRoundHandler.myMatchData = matchToBeEntered?.matchData
//            newRoundHandler.localPlayerIsPlayer0 = localPlayerIsPlayer0
//            newRoundHandler.opponentDisplayName = opponentID
//            newRoundHandler.startNewRound(6)
//            let dvc = segue.destinationViewController as! RoundMessageViewController
//            dvc.myRoundHandler = newRoundHandler
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
        //deleteUsersMatches()
        matchHelper?.joinOrStartRandomGame()
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        matchHelper?.loadExistingMatches()
    }
    
}





