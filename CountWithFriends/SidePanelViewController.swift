//
//  SidePanelViewController.swift
//  CountWithFriends
//
//  Created by joy on 6/29/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var placeHolderText = ["Email us at countoffapp@gmail.com", "with any feedback!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
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