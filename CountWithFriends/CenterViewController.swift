//
//  CenterViewController.swift
//  CountWithFriends
//
//  Created by joy on 6/29/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

protocol CenterViewControllerDelegate {
     func toggleRightPanel()
}

class CenterViewController: UIViewController {
    
    var delegate: CenterViewControllerDelegate?

    @IBAction func onProfilePressed(sender: AnyObject) {
        
        delegate?.toggleRightPanel()
    }
}
