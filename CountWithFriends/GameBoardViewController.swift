//
//  GameBoardViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OperationTableViewCellDelegate, ClockViewDelegate {

    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet var gameNumberButtons: [UIButton]!
    @IBOutlet var gameOperatorButtons: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    
    var operations: [Operation]? = []
    
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

    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewSize = self.targetLabel.layer.frame.size.height
        let view = ClockView(frame: CGRectMake(0, 0, viewSize, viewSize))
        view.delegate = self
        view.frame = CGRect(x: self.view.frame.size.width - (20 + viewSize), y: 27, width: viewSize, height: viewSize)
        
        view.setTimer(60)
        view.startClockTimer()
        self.view.addSubview(view)
    }
    
    func startNewRound(){
        let roundHandler = RoundHandler()
        roundHandler.startNewRound(6)
        targetLabel.text = String(roundHandler.target!)
        for i in 0..<roundHandler.inputNumbers!.count{
        let button = gameNumberButtons[i]
        button.setTitle(String(roundHandler.inputNumbers![i]), forState: .Normal)
        }
    }
    
    @IBAction func onOperandTapped(sender: UIButton) {
        if operations?.isEmpty == true {
            operations!.append(Operation())
        }else if operations![operations!.count-1].showOperation && operations!.count <= 4 {
            operations!.append(Operation())
        }
        
        let currentOp = operations![operations!.count-1]
        currentOp.addOperand((sender.titleLabel?.text)!, button: sender)
        currentOp.checkOperation()
        
        tableView.reloadData()

    }
    
    @IBAction func onOperatorTapped(sender: UIButton) {
        if operations?.isEmpty == true{
            operations!.append(Operation())
        } else if operations![operations!.count-1].showOperation && operations!.count <= 4 {
            operations!.append(Operation())
        }
        
        let currentOp = operations![operations!.count-1]
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
            tableView.reloadData()
        }
    }

    @IBAction func onFinishedGameTapped(sender: AnyObject) {
        
    }
    
    //TableView functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID", forIndexPath: indexPath) as! OperationTableViewCell
        let currentOp = operations![indexPath.row]
        cell.delegate = self
        cell.backgroundColor = UIColor.clearColor()
        cell.firstOperandLabel.text = currentOp.firstOperand as String
        cell.operationLabel.text = currentOp.operation as String
        cell.secondOperandLabel.text = currentOp.secondOperand as String
        cell.outputValueButton.setTitle(currentOp.outputValue as String, forState: .Normal)
        cell.equalLabel.hidden = !currentOp.showOperation
        cell.outputValueButton.hidden = !currentOp.showOperation
        
        if(indexPath.row == operations!.count-1) {
            cell.removeRowButton.hidden = false
        } else {
            cell.removeRowButton.hidden = true
        }
        
        return cell
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
        currentOp.addOperand((button.titleLabel?.text)!, button: button)
        currentOp.checkOperation()
        tableView.reloadData()
    }
    
    func timeExpired(sender: ClockView) {
        print("You Failed")
    }
    
}