//
//  GameBoardViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit


class GameBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OperationTableViewCellDelegate, ClockViewDelegate, OperationDelegate,UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet var gameNumberButtons: [UIButton]!
    @IBOutlet var gameOperatorButtons: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var historyButton: UIButton!
    
    
    var myRoundHandler: RoundHandler?
    var operations: [Operation]? = []
    var clockView: ClockView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
        tableView.separatorColor = UIColor(red:0.74, green:0.84, blue:0.95, alpha:1.00)
        let tempImageView = UIImageView.init(image: UIImage.init(named: "Portrait"))
        tempImageView.frame = tableView.bounds
        tableView.backgroundView = tempImageView
        tableView.allowsSelection = false
        tableView.superview!.layer.shadowColor = UIColor.blackColor().CGColor
        tableView.superview!.layer.shadowOpacity = 0.5
        tableView.superview!.layer.shadowOffset = CGSizeZero
        tableView.superview!.layer.shadowRadius = 3
        finishButton.enabled = false
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let viewSize = self.targetLabel.layer.frame.size.height
        clockView = ClockView(frame: CGRectMake(0, 0, viewSize/1.5, viewSize/1.5))
        clockView!.delegate = self
        clockView!.frame = CGRect(x: 15, y: topBarView.frame.height + 27, width: viewSize, height: viewSize)
        
        clockView!.setTimer(60)
        //TODO: Start clock on user indication
        //view.startClockTimer()
        self.view.addSubview(clockView!)
    }
    
    func startNewRound(){
//        let roundHandler = RoundHandler()
//        roundHandler.startNewRound(6)
        if myRoundHandler != nil{
            for i in 0..<myRoundHandler!.inputNumbers!.count{
                let button = gameNumberButtons[i]
                button.setTitle(String(myRoundHandler!.inputNumbers![i]), forState: .Normal)
            }
            targetLabel.text = String(myRoundHandler!.target!)
        }
    }
    
    @IBAction func onOperandTapped(sender: UIButton) {
        if operations?.isEmpty == true {
            operations!.append(Operation())
        }else if operations![operations!.count-1].showOperation && operations!.count <= 4 {
            operations!.append(Operation())
        }
        
        let currentOp = operations![operations!.count-1]
        if currentOp.delegate == nil {
            currentOp.delegate = self
        }
        currentOp.addOperand((sender.titleLabel?.text)!, button: sender)
        currentOp.checkOperation()

        finishButton.enabled = shouldEnableFinished()
        tableView.reloadData()

    }
    
    @IBAction func onOperatorTapped(sender: UIButton) {
        if operations?.isEmpty == true{
            operations!.append(Operation())
        } else if operations![operations!.count-1].showOperation && operations!.count <= 4 {
            operations!.append(Operation())
        }
        
        let currentOp = operations![operations!.count-1]
        if currentOp.delegate == nil {
            currentOp.delegate = self
        }
        currentOp.operation = (sender.titleLabel?.text)!

        currentOp.checkOperation()
        tableView.reloadData()
    }
    
    @IBAction func onClearTapped(sender: AnyObject) {
        for _ in 0..<operations!.count {
            let removedOperation = operations!.removeLast()
            removedOperation.firstButton?.enabled = true
            removedOperation.secondButton?.enabled = true
        }
        errorLabel.hidden = true
        finishButton.enabled = false
        tableView.reloadData()
    }
    
    @IBAction func onUndoTapped(sender: AnyObject) {
        if operations!.isEmpty == false {
            let undoOperation = operations!.last! as Operation
            if undoOperation.firstOperand == "" {
                operations!.removeLast()
            } else {
                undoOperation.undoAction()
                undoOperation.checkOperation()
            }
            finishButton.enabled = shouldEnableFinished()
            tableView.reloadData()
        }
    }
    
    @IBAction func onFinishedGameTapped(sender: AnyObject) {
        clockView!.stopTimer()
        let timeRemaining = Int(clockView!.label.text!)
        let finalResult = operations?.last?.outputValue.integerValue
        let scoreReturn = myRoundHandler?.getScoreIfRoundComplete(finalResult!, timeRemaining: timeRemaining!)
        var player0ScoreSummand = 0
        var player1ScoreSummand = 0
        if scoreReturn?.currentPlayerDidWin != nil{
            //update score because round is over. Show win or loss message/window
            if scoreReturn!.currentPlayerDidWin!{
                if myRoundHandler!.localPlayerIsPlayer0!{
                    player0ScoreSummand += scoreReturn!.score!
                }
                else{
                    player1ScoreSummand += scoreReturn!.score!
                }
            }
            //if opponent won...
            else{
                if myRoundHandler!.localPlayerIsPlayer0!{
                    player1ScoreSummand += scoreReturn!.score!
                }
                else{
                    player0ScoreSummand += scoreReturn!.score!
                }
            }
        }
        var roundEquations = Array<String>()
        for op in operations!{
            roundEquations.append(op.asString())
        }
        myRoundHandler?.saveRoundData(roundEquations, finalResult: finalResult!, player0ScoreSummand: player0ScoreSummand, player1ScoreSummand: player1ScoreSummand, timeRemaining: timeRemaining!)
    }
    
    func shouldEnableFinished() -> Bool {
        if operations?.count <= 4 {
            return false
        } else if let second = operations?.last?.secondButton {
            if !second.enabled {
                return true
            }
        }
        return false
    }
    
    //TableView functions
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.height/5
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.restorationIdentifier! == "1" {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! OperationTableViewCell
        let currentOp = operations![indexPath.row]
        cell.delegate = self
        cell.backgroundColor = UIColor.clearColor()
        cell.firstOperandLabel.text = currentOp.firstOperand as String
        cell.operationLabel.text = currentOp.operation as String
        cell.secondOperandLabel.text = currentOp.secondOperand as String
        cell.outputValueButton.setTitle(currentOp.outputValue as String, forState: .Normal)
        
        if(currentOp.brokeRules) {
            cell.firstOperandLabel.textColor = UIColor.redColor()
            cell.operationLabel.textColor = UIColor.redColor()
            cell.secondOperandLabel.textColor = UIColor.redColor()
        } else {
            cell.firstOperandLabel.textColor = UIColor.blackColor()
            cell.operationLabel.textColor = UIColor.blackColor()
            cell.secondOperandLabel.textColor = UIColor.blackColor()
        }
        
        cell.equalLabel.hidden = !currentOp.showOperation
        cell.outputValueButton.hidden = !currentOp.showOperation
        
        if(indexPath.row == operations!.count-1) {
            cell.removeRowButton.hidden = false
        } else {
            cell.removeRowButton.hidden = true
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destinationViewController as! roundHistoryTableViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.popoverPresentationController?.sourceView = historyButton
            popoverViewController.popoverPresentationController?.sourceRect = historyButton.bounds
        }
    }
    
    // Custom delegate methods for custom table cell
    
    func didRemoveOperation(sender: OperationTableViewCell) {
        let removedOperation = operations!.removeLast()
        removedOperation.firstButton?.enabled = true
        removedOperation.secondButton?.enabled = true
        tableView.reloadData()
    }
    
    func didUseOutput(sender: OperationTableViewCell, button: UIButton) {
        if operations![operations!.count-1].showOperation && operations!.count <= 4 {
            operations!.append(Operation())
        }
    
        let currentOp = operations![operations!.count-1]
        if currentOp.delegate == nil {
            currentOp.delegate = self
        }
        currentOp.addOperand((button.titleLabel?.text)!, button: button)
        currentOp.checkOperation()
        finishButton.enabled = shouldEnableFinished()
        tableView.reloadData()
    }
    
    func didBreakRules(operation: Operation, rule: String, broken: Bool) {
        errorLabel.text = rule
        errorLabel.hidden = broken
    }
    
    func timeExpired(sender: ClockView) {
        print("You Failed")
    }
    
}