//
//  GCTurnBasedMatchHelper.swift
//  CountWithFriends
//
//  Created by Andrew Bihl on 6/28/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import GameKit

protocol GCTurnBasedMatchHelperDelegate {
    func attemptGameCenterLogin(loginView: UIViewController)
    func didJoinOrCreateMatch(match:GKTurnBasedMatch)
}

class GCTurnBasedMatchHelper: NSObject, GKLocalPlayerListener{
    static let sharedInstance = GCTurnBasedMatchHelper()
    var menuViewController : UIViewController?
    var userAuthenticated = false
    var delegate : GCTurnBasedMatchHelperDelegate?
    var myMatch : GKTurnBasedMatch?
    override init(){
        super.init()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(authenticationChanged), name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }

    func joinOrStartRandomGame(){
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        request.defaultNumberOfPlayers = 2
        
        GKTurnBasedMatch.findMatchForRequest(request) { (match: GKTurnBasedMatch?, error: NSError?) in
            if error != nil{
                print("Error in searching for game match: \(error)")
            }
            else if match != nil{
                self.myMatch = match!
                var matchDataDict = Dictionary<String,AnyObject>()
                if match?.participants?[1].player == nil {
                    print("Created a new match")
                    matchDataDict.updateValue(0, forKey: "player0Score")
                    matchDataDict.updateValue(0, forKey: "player1Score")
                    //Fill in data for local user as "player1"
                }else{
                    print("Found a match!")
                    //Fill in data for local user as "player2"
                }
                
                let updatedMatchData = NSKeyedArchiver.archivedDataWithRootObject(matchDataDict)
                
                match?.saveCurrentTurnWithMatchData(NSData(), completionHandler: { (error: NSError?) in
                    if error != nil{
                        print("Error in saving data: \(error)")
                    } else{
                        match?.endTurnWithNextParticipants((match!.participants)!, turnTimeout: 3600, matchData: updatedMatchData, completionHandler: { (error: NSError?) in
                            if error != nil{
                                print("WHAT THE FUCKK")
                            }else{
                                self.delegate?.didJoinOrCreateMatch(match!)
                            }
                        })
                    }
                })
                
            }
        }
    }

    func authenticationChanged(){
        if GKLocalPlayer.localPlayer().authenticated && !userAuthenticated{
            print("Authentication changed: user now authenticated")
            userAuthenticated = true
        } else if GKLocalPlayer.localPlayer().authenticated && userAuthenticated{
            print("Authentication changed: user no longer authenticated")
            userAuthenticated = false
        }
    }
    
    func saveRoundData(equations: [String], finalResult: Int, player0ScoreSummand: Int, player1ScoreSummand: Int, localPlayerIsPlayer0: Bool, currentMatchDataObject: Dictionary<String,AnyObject>, timeRemaining: Int){
        var updatedDataObject = currentMatchDataObject
        var playerScores = updatedDataObject["playerScores"] as! Array<Int>
        playerScores[0] += player0ScoreSummand
        playerScores[1] += player1ScoreSummand
        updatedDataObject.updateValue(playerScores, forKey: "playerScores")
        var updatedRoundOperations = updatedDataObject["roundOperations"] as! [Dictionary<String,AnyObject>]
        if !localPlayerIsPlayer0{
            //update entry for last round to include 2nd player's actions
            var lastRoundOperationsDict = updatedRoundOperations.last!
            lastRoundOperationsDict.updateValue(equations, forKey: "player1Operations")
            lastRoundOperationsDict.updateValue(finalResult, forKey: "player1Result")
            lastRoundOperationsDict.updateValue(timeRemaining, forKey: "player1TimeRemaining")
            updatedRoundOperations.popLast()
            updatedRoundOperations.append(lastRoundOperationsDict)
        }
        else{
            var newRoundOperationsDict = Dictionary<String,AnyObject>()
            newRoundOperationsDict.updateValue(equations, forKey: "player0Operations")
            newRoundOperationsDict.updateValue(finalResult, forKey: "player0Result")
            newRoundOperationsDict.updateValue(timeRemaining, forKey: "player0TimeRemaining")
            updatedRoundOperations.append(newRoundOperationsDict)
        }
        updatedDataObject.updateValue(updatedRoundOperations, forKey: "roundOperations")
        let newMatchData = NSKeyedArchiver.archivedDataWithRootObject(updatedDataObject)
        //Store information about round in GameCenter database
        myMatch?.saveCurrentTurnWithMatchData(newMatchData, completionHandler: nil)
    }
    
    func player(player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
        //What to do when other player quits. This ends the other player's turn, making the local player the active participant.
    }
    
    func player(player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        //What to do when the game has ended on the other player's turn.
        //Display win/loss message, final scores, potential rematch message
    }
    
    func authenticateLocalUser(){
        print("Authenticating user...")
        if !GKLocalPlayer.localPlayer().authenticated{
            GKLocalPlayer.localPlayer().authenticateHandler = {(viewController : UIViewController?, error : NSError?) -> () in
                if viewController != nil{
                    print("Should have presented view controller")
                    self.delegate?.attemptGameCenterLogin(viewController!)
                }
                else if error != nil{
                    print("Whoops. Error in authentication: \(error!)")
                }
                else{
                    print("Should be logged in now.")
                    print("MY ID IS: \(GKLocalPlayer.localPlayer().displayName!)")
                }
            }
        }else{
            print("Already authenticated.")
        }
    }
    
}
