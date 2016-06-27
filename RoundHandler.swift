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
            inputNumbers?.append(newSmallNumber)
        }
        for _ in 4...6{
            //get number divisible by 5 between 10 and 95
            let newLargeNumber = Int(arc4random_uniform(18) + 1) * 5 + 5
            inputNumbers?.append(newLargeNumber)
        }
        target = 325
    }
    
    func getScore(userResult : Int) -> (Int){
        return 9001
    }
}
