//
//  RoundHandler.swift
//  CountWithFriends
//
//  Created by Andrew Bihl on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import Foundation

//Object created when a new round is begun in the user interface.
class RoundHandler: NSObject {
    var target: Int?
    var inputNumbers: Array<Int>?
    var myMatchData: NSData?
    var myMatchDataDict: Dictionary<String,AnyObject>?
    var localPlayerIsPlayer0: Bool?
    var opponentDisplayName: String?

    func startNewRound(numberOfInputValues: Int)->(){
        print("localPlayerIsPlayer0: \(localPlayerIsPlayer0!)")
        if localPlayerIsPlayer0!{
            var currentRoundInputs = Dictionary<String,AnyObject>()

            //localPlayerIsPlayer0 --> it's a new round. Generate new numbers.
            let generatedInputs = generateNewInputValues(numberOfInputValues)
            target = generatedInputs.target
            inputNumbers = generatedInputs.inputNumbers
            currentRoundInputs.updateValue(target!, forKey: "target")
            currentRoundInputs.updateValue(inputNumbers!, forKey: "inputNumbers")
            
            //Set up matchData for new game
            if myMatchData?.length == 0{
                myMatchDataDict = Dictionary<String, AnyObject>()
                print("MatchData is nil")
                myMatchDataDict?.updateValue([currentRoundInputs], forKey: "roundInputs")
            }
               
            //Decode current matchData into Dictionary object
            else{
                myMatchDataDict = NSKeyedUnarchiver.unarchiveObjectWithData(myMatchData!) as? Dictionary<String,AnyObject>
                var existingRoundInputs = myMatchDataDict!["roundInputs"] as! Array<Dictionary<String,AnyObject>>
                existingRoundInputs.append(currentRoundInputs)
                myMatchDataDict?.updateValue(existingRoundInputs, forKey: "roundInputs")
            }

        }
            
        else{
            myMatchDataDict = NSKeyedUnarchiver.unarchiveObjectWithData(myMatchData!) as? Dictionary<String,AnyObject>
            let roundInputs = myMatchDataDict!["roundInputs"] as! Array<Dictionary<String,AnyObject>>
            let lastRoundInputs = roundInputs.last
            target = lastRoundInputs!["target"] as! Int
            inputNumbers = lastRoundInputs!["inputNumbers"] as! [Int]
        }
    }
    
    func generateNewInputValues(numberOfInputValues: Int)->(target: Int, inputNumbers: [Int]){
        var targetResult : Int
        var inputNumbersResult = Array<Int>()
        for _ in 1..<4{
            let newSmallNumber = Int(arc4random_uniform(9)+1)
            inputNumbersResult.append(newSmallNumber)
        }
        while inputNumbersResult.count < numberOfInputValues{
            //get number divisible by 5 between 10 and 95
            let newLargeNumber = Int(arc4random_uniform(18) + 1) * 5 + 5
            //No repeated large numbers
            if !(inputNumbersResult.contains(newLargeNumber)){
                inputNumbersResult.append(newLargeNumber)
            }
        }
        var newTarget = arc4random_uniform(900)
        newTarget += 100
        targetResult = Int(newTarget)
        return (targetResult, inputNumbersResult)
    }
    
    func getPreviousRoundOperations()->[Dictionary<String,AnyObject>]?{
        let roundOperationsDict = myMatchDataDict!["roundOperations"] as? [Dictionary<String,AnyObject>]
        return roundOperationsDict
    }
    
    //Return player's score and opponents score, or nil for both if final round was not finished.
    //Only called by 2nd player at end of a round
    func getGameFinalScores()->(localPlayerScore: Int?, opponentScore: Int?){
        //Check if just played Round 3
        if (myMatchDataDict!["roundInputs"]!.count >= 3){
            print("END OF GAME!")
            let playerScores = myMatchDataDict!["playerScores"] as! [Int]
            if localPlayerIsPlayer0!{
                return (localPlayerScore: playerScores[0], opponentScore: playerScores[1])
            }else{
                return (localPlayerScore: playerScores[1], opponentScore: playerScores[0])
            }
        }
        else{
            return (localPlayerScore: nil, opponentScore: nil)
        }
    }
    
    func setPlayerOutcomes(localPlayerDidWin: Bool){
        if localPlayerDidWin{
            GCTurnBasedMatchHelper.sharedInstance.setPlayerOutcomes(localPlayerIsPlayer0!)
        } else{
            GCTurnBasedMatchHelper.sharedInstance.setPlayerOutcomes(!localPlayerIsPlayer0!)
        }
    }
    
    func getScoreIfRoundComplete(finalResult: Int, timeRemaining: Int)->(currentPlayerDidWin: Bool?, score: Int?){
        guard let lastRoundOperations = myMatchDataDict!["roundOperations"]?.lastObject as? Dictionary<String,AnyObject> else{
            return (nil, nil)
        }
        //Check if on new round (current round data not yet stored)
        if lastRoundOperations.keys.contains("player1Operations"){
            return (nil, nil)
        }
        else{
            //TODO: Calculate score.
            let opponentResult = lastRoundOperations["player0Result"] as! Int
            let opponentTimeRemaining = lastRoundOperations["player0TimeRemaining"] as! Int
            var localPlayerWon = true
            let localPlayerDifference = target! - finalResult
            let opponentDifference = target! - opponentResult
            //if tie occured
            if localPlayerDifference < opponentDifference{
                localPlayerWon = true
            }
            else if localPlayerDifference > opponentDifference{
                localPlayerWon = false
            }
            else{
                if timeRemaining < opponentTimeRemaining{
                    return (true, opponentTimeRemaining - timeRemaining)
                }
                else if timeRemaining > opponentTimeRemaining{
                    return (false, timeRemaining - opponentTimeRemaining)
                }
                else{
                    //True tie
                    return (false, 0)
                }
            }
            var resultDifference = (target! - finalResult)-(target! - opponentResult)
            //localPlayer lost or Tied
            resultDifference = abs(resultDifference)
            var calculatedRoundScore = 100 + (5 * resultDifference)
            if localPlayerWon{
                calculatedRoundScore = calculatedRoundScore + opponentTimeRemaining - timeRemaining
            }
            else{
                calculatedRoundScore = calculatedRoundScore + timeRemaining - opponentTimeRemaining
            }
            //Double score on bullseye
            if finalResult == target! || opponentResult == target!{
                calculatedRoundScore *= 2
            }
            return (localPlayerWon, calculatedRoundScore)
        }
    }
    
    func saveRoundData(equations: [String], finalResult: Int, player0ScoreSummand: Int, player1ScoreSummand: Int, timeRemaining: Int){
        //Save round information to database.
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            GCTurnBasedMatchHelper.sharedInstance.saveRoundData(equations, finalResult: finalResult, player0ScoreSummand: player0ScoreSummand, player1ScoreSummand: player1ScoreSummand, localPlayerIsPlayer0: self.localPlayerIsPlayer0!, currentMatchDataObject: self.myMatchDataDict!, timeRemaining: timeRemaining)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print("This is run on the main queue, after the previous code in outer block")
            })
        })
    }
    
    func endRound(){
        //GCTurnBasedMatchHelper.sharedInstance.endRound(localPlayerIsPlayer0!)
    }
    
    func endGame(){
        //End of game functions
        GCTurnBasedMatchHelper.sharedInstance.endGame()
        GCTurnBasedMatchHelper.sharedInstance.myMatch = nil
        
    }
   
//    
//    func getScore(userResult : Int) -> (Int){
//        return 9001
//    }
}

//Use input values to generate a target value
//    func generateTarget(){
//        target = 0
//        var values = Array<Int>()
//        for number in inputNumbers!{
//            values.append(number)
//        }
//        target = values[0]
//        values.removeAtIndex(0)
//        while values.count > 0{
//            let randomIndex = Int(arc4random_uniform(UInt32(values.count)))
//            let num = values[randomIndex]
//            var operatorSelector = arc4random_uniform(6)
//            //print(operatorSelector)
//            if operatorSelector < 3{
//                //Do subtraction if does not create negative
//                if target! - num > 0{
//                    print("Subtracted \(num) from \(target!)")
//                    target! -= num
//                    values.removeAtIndex(randomIndex)
//                    continue
//                }
//                //otherwise try to do division
//                else{
//                    operatorSelector += 1
//                }
//            }
//            if operatorSelector == 3{
//                //if can divide to an integer
//                if target! % num == 0{
//                    print("Divided \(target!) by \(num))")
//                    target! /= num
//                    values.removeAtIndex(randomIndex)
//                    continue
//                }
//                //otherwise move on to multiplication or addition by adding 1 or 2
//                else{
//                    operatorSelector += arc4random_uniform(2) + 1
//                }
//            }
//            if operatorSelector == 4 && target! * num < 5000{
//                print("Multiplied \(target!) by \(num)")
//                target! *= num
//                values.removeAtIndex(randomIndex)
//                continue
//            }
//            else {
//                print("Added \(num) to \(target!)")
//                target! += num
//                values.removeAtIndex(randomIndex)
//            }
//
//        }
//
//    }


