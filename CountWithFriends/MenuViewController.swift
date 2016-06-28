//
//  MenuViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/27/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, GCTurnBasedMatchHelperDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        let matchHelper = GCTurnBasedMatchHelper()
        matchHelper.delegate = self
        matchHelper.authenticateLocalUser()
    }
    
    func attemptGameCenterLogin(loginView: UIViewController) {
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    
    @IBAction func onStartGameTapped(sender: AnyObject) {
        performSegueWithIdentifier("startGameSegue", sender: sender)
    }

}
