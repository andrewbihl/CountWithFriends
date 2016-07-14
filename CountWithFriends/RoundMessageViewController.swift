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
    //@IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var player0Label: UILabel!
    @IBOutlet weak var player0ScoreLabel: UILabel!
    @IBOutlet weak var player0Box: UIView!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player1Box: UIView!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var beginMatchButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    
    var localPlayerInfo: (name: String, score: Int)?
    var opponentInfo: (name: String, score: Int)?
    var roundNumber : Int?
    var matchToBeEntered: GKTurnBasedMatch?
    var gameIsFinished = false
    var opponentID: String?
    var localPlayerIsPlayer0 = false
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if localPlayerInfo == nil{
            localPlayerInfo = (name: "Me", score: 0)
        }
        player0Label.text = localPlayerInfo!.name
        player0ScoreLabel.text = "Score: \(localPlayerInfo!.score)"

        if opponentInfo == nil{
            opponentInfo = (name: "New Opponent", score: 0)
        }
        player1Label.text = opponentInfo!.name
        player1ScoreLabel.text = "Score: \(opponentInfo!.score)"
        
        self.infoView.backgroundColor = UIColor.sunsetOverlay()
        self.beginMatchButton.backgroundColor = UIColor.sunsetOverlay()
        self.beginMatchButton.setTitleColor(UIColor.sunsetOverlayLightText(), forState: .Normal)
        
        player0Box.backgroundColor = UIColor.sunsetOverlay()
        player1Box.backgroundColor = UIColor.sunsetOverlay()
        addGradiant(UIColor.sunsetLight(), bottomColor: UIColor.sunsetDark())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //animateNewGradiant(UIColor.midnightLight(), newBottomColor: UIColor.midnightDark())
    }
    
    private func addGradiant(topColor: UIColor, bottomColor: UIColor) {
        let colorArray:[CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let locations:[Int] = [0,1]
        gradient.colors = colorArray
        gradient.frame = self.view.frame
        gradient.locations = locations
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func animateNewGradiant(newTopColor: UIColor, newBottomColor: UIColor) {
        CATransaction.begin()
        CATransaction.setAnimationDuration(60)
        gradient.colors = [newTopColor.CGColor,newBottomColor.CGColor]
        CATransaction.commit()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let newRoundHandler = RoundHandler()
        newRoundHandler.myMatchData = matchToBeEntered?.matchData
        newRoundHandler.localPlayerIsPlayer0 = localPlayerIsPlayer0
        newRoundHandler.opponentDisplayName = opponentID
        
        let outcome = matchToBeEntered?.participants![0].matchOutcome
        
        let dvc = segue.destinationViewController as! GameBoardViewController
        dvc.myRoundHandler = newRoundHandler
        dvc.localPlayer = localPlayerInfo!.name
        dvc.opponentPlayer = opponentInfo!.name
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
