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
    func didPassTurn()
    func didLoginToGameCenter()
    func attemptGameCenterLogin(loginView: UIViewController)
    func didJoinOrCreateMatch(match: GKTurnBasedMatch?, error: NSError?)
    func didLoadExistingMatches(yourTurnMatches: Array<GameSnapshot>, theirTurnMatches: Array<GameSnapshot>)
}

class GCTurnBasedMatchHelper: NSObject, GKLocalPlayerListener{
    static let sharedInstance = GCTurnBasedMatchHelper()
    var menuViewController : UIViewController?
    var userAuthenticated = false
    var delegate : GCTurnBasedMatchHelperDelegate?
    var localPlayerWon: Bool?
    var myMatch : GKTurnBasedMatch?{
        didSet(newMatch){
            localPlayerWon = false
        }
    }
    override init(){
        super.init()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(authenticationChanged), name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }

    func resumeGame(matchID: String){
        GKTurnBasedMatch.loadMatchWithID(matchID) { (match: GKTurnBasedMatch?, error: NSError?) in
            if error != nil{
                print("There was a problem resuming the match: \n\(error)")
                self.delegate?.didJoinOrCreateMatch(nil, error: error)
            }else{
                self.myMatch = match!
                self.delegate?.didJoinOrCreateMatch(match!, error: nil)
            }
        }
    }
    
    func joinOrStartRandomGame(){
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        request.defaultNumberOfPlayers = 2
        
        GKTurnBasedMatch.findMatchForRequest(request) { (match: GKTurnBasedMatch?, error: NSError?) in
            if error != nil{
                print("Error in searching for game match: \(error)")
                self.delegate?.didJoinOrCreateMatch(nil, error: error)
            }
            else if match != nil{
                self.myMatch = match!
                self.delegate?.didJoinOrCreateMatch(match!, error: nil)
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
    
    //Saves data to GameCenter database and ends game if last round
    func saveRoundData(equations: [String], finalResult: Int, player0ScoreSummand: Int, player1ScoreSummand: Int, localPlayerIsPlayer0: Bool, currentMatchDataObject: Dictionary<String,AnyObject>, timeRemaining: Int, roundNumber: Int){
        var updatedDataObject = currentMatchDataObject
        var playerScores = updatedDataObject["playerScores"] as? Array<Int>
        if playerScores != nil{
            playerScores![0] += player0ScoreSummand
            playerScores![1] += player1ScoreSummand
        }
        else{
            playerScores = [player0ScoreSummand, player1ScoreSummand]
        }
        updatedDataObject.updateValue(playerScores!, forKey: "playerScores")
        var updatedRoundOperations = updatedDataObject["roundOperations"] as? [Dictionary<String,AnyObject>]
        if updatedRoundOperations == nil{
            updatedRoundOperations = Array<Dictionary<String,AnyObject>>()
        }
        
        if !localPlayerIsPlayer0{
            //update entry for last round to include 2nd player's actions
            var lastRoundOperationsDict = updatedRoundOperations!.last!
            lastRoundOperationsDict.updateValue(equations, forKey: "player1Operations")
            lastRoundOperationsDict.updateValue(finalResult, forKey: "player1Result")
            lastRoundOperationsDict.updateValue(timeRemaining, forKey: "player1TimeRemaining")
            updatedRoundOperations!.popLast()
            updatedRoundOperations!.append(lastRoundOperationsDict)
        }
        else{
            var newRoundOperationsDict = Dictionary<String,AnyObject>()
            newRoundOperationsDict.updateValue(equations, forKey: "player0Operations")
            newRoundOperationsDict.updateValue(finalResult, forKey: "player0Result")
            newRoundOperationsDict.updateValue(timeRemaining, forKey: "player0TimeRemaining")
            updatedRoundOperations!.append(newRoundOperationsDict)
        }
        updatedDataObject.updateValue(updatedRoundOperations!, forKey: "roundOperations")
        let newMatchData = NSKeyedArchiver.archivedDataWithRootObject(updatedDataObject)
        //Store information about round in GameCenter database
        myMatch?.saveCurrentTurnWithMatchData(newMatchData, completionHandler: { (error: NSError?) in
            if error != nil{
                print("Failed to save data: \(error)")
            }
            else{
                if roundNumber >= 3 && !localPlayerIsPlayer0{
                    self.endGame()
                } else {
                    self.endRound(localPlayerIsPlayer0)
                }
            }
        })
//        myMatch?.saveCurrentTurnWithMatchData(newMatchData, completionHandler: { (error: NSError?) in
//            if error != nil{
//                print("Failed to save data: \(error)")
//            }else{
////                print(updatedDataObject)
////                print("INPUTS: ")
////                print(updatedDataObject["roundInputs"])
////                print("OPERATIONS:")
////                print(updatedDataObject["roundOperations"])
//                print("Data saved for round")
//            }
//            self.myMatch = nil
//        })
    }
    
    private func endRound(currentPlayerIsPlayer0: Bool){
        var otherParticipants = Array<GKTurnBasedParticipant>()
        if currentPlayerIsPlayer0{
            otherParticipants.append(myMatch!.participants![1])
        }else{
            otherParticipants.append(myMatch!.participants![0])
        }
        myMatch!.endTurnWithNextParticipants(otherParticipants, turnTimeout: 3600, matchData: (myMatch?.matchData)!) { (error: NSError?) in
            if error != nil{
                print("Somehow passing the turn got f**ked up. Error: \(error)")
            }
            else{
                print("Turn passed")
                self.myMatch = nil
                self.delegate?.didPassTurn()
            }
        }
    }
    
    func endGame(){
        //myMatch?.endMatchInTurnWithMatchData((myMatch?.matchData)!, completionHandler: nil)
        //SET PLAYER OUTCOMES
        if myMatch!.participants![0].playerID == GKLocalPlayer.localPlayer().playerID{
            if localPlayerWon!{
                myMatch?.participants![0].matchOutcome = .Won
                myMatch?.participants![1].matchOutcome = .Lost
            } else{
                myMatch?.participants![1].matchOutcome = .Won
                myMatch?.participants![0].matchOutcome = .Lost
            }
        }
        else{
            if localPlayerWon!{
                myMatch?.participants![1].matchOutcome = .Won
                myMatch?.participants![0].matchOutcome = .Lost
            } else{
                myMatch?.participants![0].matchOutcome = .Won
                myMatch?.participants![1].matchOutcome = .Lost
            }
        }
        myMatch?.endMatchInTurnWithMatchData(myMatch!.matchData!, completionHandler: { (error: NSError?) in
            if error != nil{
                print("Failed to end match: \(error)")
            } else{
                self.myMatch = nil
            }
        })
    }
    
    func setPlayerOutcomes(localPlayerdidWin: Bool){
        localPlayerWon = localPlayerdidWin
    }
        
    func player(player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
        print("Other player quit")
        //What to do when other player quits. This ends the other player's turn, making the local player the active participant.
    }
    
    func player(player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        //What to do when the game has ended on the other player's turn.
        //Display win/loss message, final scores, potential rematch message
    }
    
    func loadExistingMatches(){
        GKTurnBasedMatch.loadMatchesWithCompletionHandler { (matches: [GKTurnBasedMatch]?, error: NSError?) in
            if error != nil{
                print("Error in loading player's active matches: \(error)")
            }
            else{
                if matches == nil{
                    return
                }
                var yourTurnMatches = Array<GameSnapshot>()
                var theirTurnMatches = Array<GameSnapshot>()
                for match in matches!{
                    if match.participants![0].matchOutcome != .None{
                        match.removeWithCompletionHandler(nil)
                    }
                    else{
                        let matchSnapshot = GameSnapshot()
                        var playerScores = [0,0]
                        if match.matchData?.length > 0 {
                            let dataDict = NSKeyedUnarchiver.unarchiveObjectWithData(match.matchData!) as? Dictionary<String,AnyObject>
                            let roundOperations = dataDict!["roundOperations"] as! Array<Dictionary<String,AnyObject>>
                            //if at beginning of new round
                            if roundOperations.last?["player1Operations"] != nil && match.currentParticipant?.playerID == match.participants![0].playerID {
                                matchSnapshot.currentRound = roundOperations.count + 1
                            } else{
                                matchSnapshot.currentRound = roundOperations.count
                            }
                            playerScores = dataDict!["playerScores"] as! [Int]
                        }
                        matchSnapshot.matchID = match.matchID!
                        var opponentName : String?
//                        print(match.participants)
//                        for participant in match.participants!{
//                            if participant.playerID != GKLocalPlayer.localPlayer().playerID{
//                                opponentName = participant.player?.displayName
//                            }
//                        }
                        for i in 0...1{
                            let participant = match.participants![i]
                            if participant.playerID != GKLocalPlayer.localPlayer().playerID{
                                opponentName = participant.player?.displayName
                                matchSnapshot.opponentScore = playerScores[i]
                            }
                            else{
                                matchSnapshot.yourName = participant.player!.displayName!
                                matchSnapshot.yourScore = playerScores[i]
                            }
                        }
                        
                        if opponentName == nil{
                            opponentName = "Awaiting \nOpponent"
                        }
                        else{
                            //If display name is alias it will present with non-ASCII quotes. Remove these.
                            opponentName = opponentName!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\u{200e}\u{200e}\u{201c}\u{201d}\u{202a}\u{202c}"))
                        }
                        matchSnapshot.opponentName = opponentName!
                        //If it is your turn...
                        if match.currentParticipant?.playerID == GKLocalPlayer.localPlayer().playerID && opponentName != "Awaiting \nOpponent"{
                            yourTurnMatches.append(matchSnapshot)
                        }
                        else{
                            theirTurnMatches.append(matchSnapshot)
                        }
                    }
                }
                print(matches!.count)
                self.delegate?.didLoadExistingMatches(yourTurnMatches, theirTurnMatches: theirTurnMatches)
            }
        }
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
                    self.delegate?.didLoginToGameCenter()
                }
            }
        }else{
            print("Already authenticated.")
        }
    }
    
}
