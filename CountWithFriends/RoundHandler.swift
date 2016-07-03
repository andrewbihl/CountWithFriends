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
    //nil only if other player hasn't played round yet.
    var opponentScoreForCurrentRound: Int?
    
    func startNewRound(numberOfInputValues: Int)->(){
        inputNumbers = Array()
        target = nil
        //TODO: Set sharedInstance.myMatch to the match being shown so that it can send and retrieve data to/from corrent match in GameCenter.
        //GCTurnBasedMatchHelper.sharedInstance.myMatch =
        for _ in 1..<4{
            let newSmallNumber = Int(arc4random_uniform(9)+1)
            inputNumbers!.append(newSmallNumber)
        }
        while inputNumbers?.count < numberOfInputValues{
            //get number divisible by 5 between 10 and 95
            let newLargeNumber = Int(arc4random_uniform(18) + 1) * 5 + 5
            //No repeated large numbers
            if !(inputNumbers?.contains(newLargeNumber))!{
                inputNumbers!.append(newLargeNumber)
            }
        }
        generateTarget()
    }
    
    func getScoreIfRoundComplete(finalResult: Int)->(currentPlayerWon: Bool?, score: Int?){
        if opponentScoreForCurrentRound == nil{
            return (nil, nil)
        }
        else{
            //TODO: Calculate score.
            return (true, 1283152)
        }
    }
    
    func endRound(equations: [String], finalResult: Int, roundScore: Int?, player0DidWin: Bool?){
        GCTurnBasedMatchHelper.sharedInstance.saveRoundData(equations, playerResultForRound: finalResult, finalRoundScore: roundScore, player0DidWin: nil)
        //Save round information to database.
    }
    
    func endGame(){
        //End of game functions
        GCTurnBasedMatchHelper.sharedInstance.myMatch = nil
        
    }
    
    func generateTarget(){
        var newTarget = arc4random_uniform(900)
        newTarget += 100
        target = Int(newTarget)
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


