//
//  SidePanelViewController.swift
//  CountWithFriends
//
//  Created by joy on 6/29/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

protocol SidePanelViewControllerDelegate {
    
}


class SidePanelViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    // var animals: Array<Animal>!
    var placeHolderText = ["Friends", "Username", "Solo", "Random Opponent", "Profile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension SidePanelViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeHolderText.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rightCellID", forIndexPath: indexPath)
        
        cell.textLabel?.text = placeHolderText[indexPath.row]
        
        return cell
    }
    
}

// Mark: Table View Delegate

extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
}