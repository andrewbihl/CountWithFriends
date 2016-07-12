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
    var gameIsFinished = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !gameIsFinished{
            startNewRound()
        } else{
            myRoundHandler?.generateMyMatchDataDict()
            gameDidFinish()
        }
        tableView.rowHeight = tableView.frame.size.height/5
        let viewSize = self.targetLabel.layer.frame.size.height
        clockView = ClockView(frame: CGRectMake(0, 0, viewSize/1.5, viewSize/1.5))
        clockView!.delegate = self
        clockView!.frame = CGRect(x: 15, y: topBarView.frame.height + 27, width: viewSize, height: viewSize)
        
        clockView!.setTimer(60)
        //TODO: Start clock on user indication
        clockView!.startClockTimer()
        self.view.addSubview(clockView!)
    }
    
    override func viewDidLayoutSubviews() {
        let buttonFontSize = floor(gameNumberButtons[0].frame.size.width * 0.3)
        let targetFontSize = floor(targetLabel.frame.width * 0.25)
        targetLabel.font = UIFont(name: targetLabel.font!.fontName, size: targetFontSize)
        
        for button in gameNumberButtons {
            button.titleLabel!.font = UIFont(name: button.titleLabel!.font!.fontName, size: buttonFontSize)
        }
        
        for button in gameOperatorButtons {
            button.titleLabel!.font = UIFont(name: button.titleLabel!.font!.fontName, size: buttonFontSize)
        }
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
    
    
    func gameDidFinish()->Bool{
        //Get winner if game is over.
        let gameWinResult = myRoundHandler?.getGameFinalScores()
        if gameWinResult?.localPlayerScore != nil{
            if gameWinResult!.localPlayerScore > gameWinResult!.opponentScore{
                myRoundHandler?.setPlayerOutcomes(true)
                presentGameOverMessage(true, gameWinResult: gameWinResult!)
            }else{
                myRoundHandler?.setPlayerOutcomes(false)
                presentGameOverMessage(false, gameWinResult: gameWinResult!)
            }
            //-----------DISPLAY ANY RELEVANT CONTROLLERS/VIEW HERE------
            return true
        }
        else{
            return false
        }
    }
    
    func presentGameOverMessage(localPlayerDidWin: Bool, gameWinResult:(localPlayerScore: Int?, opponentScore: Int?)){
        var gameOverAlert: UIAlertController
        if localPlayerDidWin{
            print("I WON THE GAME WITH A SCORE OF \(gameWinResult.localPlayerScore). Opponent had score of \(gameWinResult.opponentScore)")
            
            gameOverAlert = UIAlertController(title: "You Won the Game!", message: "Congratulations. You won with a score \(gameWinResult.localPlayerScore!) vs your opponent's score of \(gameWinResult.opponentScore!)", preferredStyle: .Alert)
        }
        else{
            print("I LOST THE GAME WITH A SCORE OF \(gameWinResult.localPlayerScore!). Opponent had score of \(gameWinResult.opponentScore!)")
            gameOverAlert = UIAlertController(title: "You Lost the Game!", message: "You suck. Your opponent beat you with a score \(gameWinResult.opponentScore!) vs your shitty score of \(gameWinResult.localPlayerScore!)", preferredStyle: .Alert)
        }
        let dismissAction = UIAlertAction(title: "Okay", style: .Default, handler: { (action: UIAlertAction) in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        gameOverAlert.addAction(dismissAction)
        self.presentViewController(gameOverAlert, animated: true, completion: nil)
    }
    
    @IBAction func onFinishedGameTapped(sender: UIButton) {
        sender.enabled = false
        clockView!.stopTimer()
        self.finishedRound()
    }
    
    func finishedRound() {
        let timeRemaining = Int(clockView!.label.text!)
        let finalResult = (operations?.last?.outputValue.integerValue != nil) ? operations?.last?.outputValue.integerValue : 0
        let scoreReturn = myRoundHandler?.getScoreIfRoundComplete(finalResult!, timeRemaining: timeRemaining!)
        var player0ScoreSummand = 0
        var player1ScoreSummand = 0
        
        //Check if END of Round
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
        //if game is over
        //TODO: CHECK ONLY FOR END OF GAME IF ALSO END OF ROUND (move up into if statement)
        if !myRoundHandler!.localPlayerIsPlayer0! && gameDidFinish(){
            myRoundHandler?.endGame()
        }
        
        else{
            //dismissViewControllerAnimated(true, completion: nil)
            performSegueWithIdentifier("unwindToMenu", sender: self)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func shouldEnableFinished() -> Bool {
        if operations?.count <= 4 {
            return false
        } else if let second = operations?.last?.secondButton {
            if !second.enabled && !operations!.last!.brokeRules {
                return true
            }
        }
        return false
    }
    
    //Math UI functions
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
            let popoverViewController = segue.destinationViewController as! RoundHistoryTableViewController
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
            popoverViewController.popoverPresentationController?.sourceView = historyButton
            popoverViewController.popoverPresentationController?.sourceRect = historyButton.bounds
            popoverViewController.roundHandler = self.myRoundHandler
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
        self.finishedRound()
    }
    
}