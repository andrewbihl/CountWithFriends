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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onOperatorTapped(sender: UIButton) {
    }

    @IBAction func onFinishedGameTapped(sender: AnyObject) {
    }
}
