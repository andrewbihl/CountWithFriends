//
//  GameBoardViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class GameBoardViewController: UIViewController {

    @IBOutlet weak var targetLabel: UILabel!
    
    @IBOutlet var gameNumberButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
        // Do any additional setup after loading the view.
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
    
    @IBAction func onOperatorTapped(sender: UIButton) {
    }

    @IBAction func onFinishedGameTapped(sender: AnyObject) {
    }
}