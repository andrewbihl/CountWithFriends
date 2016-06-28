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
    @IBOutlet var gameOperatorButtons: [UIButton]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startNewRound()
        // Do any additional setup after loading the view.
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let viewSize = self.targetLabel.layer.frame.size.height
        let view = ClockView(frame: CGRectMake(0, 0, viewSize, viewSize))
        
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
    
    @IBAction func onOperatorTapped(sender: UIButton) {
    }

    @IBAction func onFinishedGameTapped(sender: AnyObject) {
    }
}