//
//  Operation.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/29/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

protocol OperationDelegate: class {
    
    func didBreakRules(operation: Operation, rule: String, broken: Bool)
}

class Operation: NSObject {
    
    var firstOperand: NSString = ""
    var firstButton: UIButton?
    var secondOperand: NSString = ""
    var secondButton: UIButton?
    var operation: NSString = ""
    var outputValue: NSString = ""
    var showOperation = false
    var brokeRules = false
    var delegate: OperationDelegate?
    
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
    
    func checkOutput() {
        if outputValue.integerValue < 0 {
            showOperation = false
            brokeRules = true
            delegate?.didBreakRules(self, rule: "No negative values", broken: false)
        } else if outputValue.floatValue % 1 != 0{
            showOperation = false
            brokeRules = true
            delegate?.didBreakRules(self, rule: "No decimal values", broken: false)
        } else {
            brokeRules = false
            delegate?.didBreakRules(self, rule: "",broken: true)
            outputValue = "\(outputValue.intValue)"
        }
    }
    
    func operate() {
        switch operation {
        case "+": outputValue = "\(firstOperand.intValue + secondOperand.intValue)"
        case "-": outputValue = "\(firstOperand.intValue - secondOperand.intValue)"
        case "x": outputValue = "\(firstOperand.intValue * secondOperand.intValue)"
        case "/": outputValue = "\(firstOperand.floatValue / secondOperand.floatValue)"
        default: break
        }
        checkOutput()
    }

}
