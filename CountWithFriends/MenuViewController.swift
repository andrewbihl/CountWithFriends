//
//  MenuViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func onStartGameTapped(sender: AnyObject) {
        performSegueWithIdentifier("startGameSegue", sender: sender)
    }

}
