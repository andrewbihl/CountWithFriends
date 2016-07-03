//
//  Operation.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/29/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class Operation: NSObject {
    
    var firstOperand: NSString = ""
    var firstButton: UIButton?
    var secondOperand: NSString = ""
    var secondButton: UIButton?
    var operation: NSString = ""
    var outputValue: NSString = ""
    var showOperation = false
    
    func addOperand(operand: String, button: UIButton) {
        if firstOperand == "" && button.enabled {
            firstOperand = operand
            firstButton = button
            firstButton?.enabled = false
        } else if secondOperand == "" && button.enabled{
            secondOperand = operand
            secondButton = button
            secondButton?.enabled = false
        }
    }
    
    func asString()->String{
        return "\(firstOperand)\(operation)\(secondOperand)\(outputValue)"
    }
    
    func undoAction() {
        if secondOperand != "" {
            secondOperand = ""
            secondButton?.enabled = true
            secondButton = nil
        } else if operation != "" {
            operation = ""
        } else if firstOperand != "" {
            firstOperand = ""
            firstButton?.enabled = true
            firstButton = nil
        }
    }
    
    func checkOperation() {
        if firstOperand != "" && secondOperand != "" && operation != "" {
            showOperation = true
            self.operate()
        } else {
            showOperation = false
        }
    }
    
    func operate() {
        switch operation {
        case "+": outputValue = "\(firstOperand.intValue + secondOperand.intValue)"
        case "-": outputValue = "\(firstOperand.intValue - secondOperand.intValue)"
        case "x": outputValue = "\(firstOperand.intValue * secondOperand.intValue)"
        case "/": outputValue = "\(firstOperand.intValue / secondOperand.intValue)"
        default: break
        }
    }

}
