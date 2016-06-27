//
//  RoundHandler.swift
//  CountWithFriends
//
//  Created by Andrew Bihl on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import Foundation

class RoundHandler: NSObject {
    var target: Int?
    var inputNumbers: Array<Int>?
    
    func startNewRound(numberOfInputValues: Int)->(){
        inputNumbers = Array()
        target = nil
        for _ in 1..<4{
            let newSmallNumber = Int(arc4random_uniform(9)+1)
            inputNumbers!.append(newSmallNumber)
        }
        for _ in 4...6{
            //get number divisible by 5 between 10 and 95
            let newLargeNumber = Int(arc4random_uniform(18) + 1) * 5 + 5
            inputNumbers!.append(newLargeNumber)
        }
        generateTarget()
    }
    
    //Use input values to generate a target value
    func generateTarget(){
        target = 0
        var values = Array<Int>()
        for number in inputNumbers!{
            values.append(number)
        }
        target = values[0]
        values.removeAtIndex(0)
        while values.count > 0{
            let randomIndex = Int(arc4random_uniform(UInt32(values.count)))
            let num = values[randomIndex]
            var operatorSelector = arc4random_uniform(4)
            //print(operatorSelector)
            if operatorSelector == 0{
                //Do subtraction if does not create negative
                if target! - num > 0{
                    print("Subtracted \(num) from \(target!)")
                    target! -= num
                    values.removeAtIndex(randomIndex)
                    continue
                }
                //otherwise try to do division
                else{
                    operatorSelector += 1
                }
            }
            if operatorSelector == 1{
                //if can divide to an integer
                if target! % num == 0{
                    print("Divided \(target!) by \(num))")
                    target! /= num
                    values.removeAtIndex(randomIndex)
                    continue
                }
                //otherwise move on to multiplication or addition by adding 1 or 2
                else{
                    operatorSelector += arc4random_uniform(2) + 1
                }
            }
            if operatorSelector == 2{
                print("Multiplied \(target!) by \(num)")
                target! *= num
                values.removeAtIndex(randomIndex)
                continue
            }
            else {
                print("Added \(num) to \(target!)")
                target! += num
                values.removeAtIndex(randomIndex)
            }
            
        }
        
    }
    
    func getScore(userResult : Int) -> (Int){
        return 9001
    }
}
