//
//  RoundHistoryTableViewController.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 7/6/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import GameKit

class RoundHistoryTableViewController: UITableViewController {
    
    var player0Operations: [[String]?] = []
    var player1Operations: [[String]?] = []
    var player0Times: [Int] = []
    var player1Times: [Int] = []
    var roundTargets: [Int] = []
    var roundHandler: RoundHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let targets = roundHandler?.myMatchDataDict!["roundInputs"] as? [Dictionary<String,AnyObject>]
        if let previous = roundHandler?.getPreviousRoundOperations() {
            if !previous.isEmpty {
                for dic in previous {
                    if dic.count % 2 == 0 {
                        player0Operations.append(dic["player0Operations"]! as? [String])
                        player0Times.append(60 - (dic["player0TimeRemaining"]! as! Int))
                        player1Operations.append(dic["player1Operations"]! as? [String])
                        player1Times.append(60 - (dic["player1TimeRemaining"]! as! Int))
                    }
                }
                for tar in targets! {
                    roundTargets.append(tar["target"] as! Int)
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return player0Operations.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        }
        return 6
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ROUND \(section+1): \(roundTargets[section])"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryCellID", forIndexPath: indexPath) as! RoundHistoryTableViewCell
        if(indexPath.section == 0 && indexPath.row == 0) {
            cell.player0OperationLabel.text = GKLocalPlayer.localPlayer().alias
            cell.player0OperationLabel.font = UIFont.boldSystemFontOfSize(15.0)
            cell.player1OperationLabel.text = roundHandler?.opponentDisplayName
            cell.player1OperationLabel.font = UIFont.boldSystemFontOfSize(15.0)
        } else if indexPath.section == 0 && indexPath.row == 6 {
            cell.player0OperationLabel.text = "\(player0Times[0]) seconds"
            cell.player0OperationLabel.font = UIFont.boldSystemFontOfSize(14.0)
            cell.player1OperationLabel.text = "\(player1Times[0]) seconds"
            cell.player1OperationLabel.font = UIFont.boldSystemFontOfSize(14.0)
        } else if indexPath.section == 0 && indexPath.row >= 1 {
            if let value = player0Operations[indexPath.section]?.count {
                if value >= indexPath.row {
                    cell.player0OperationLabel.text = player0Operations[indexPath.section]![indexPath.row - 1]
                } else {
                    cell.player0OperationLabel.text = "Incomplete"
                }
            }
            if let value = player1Operations[indexPath.section]?.count {
                if value >= indexPath.row {
                    cell.player1OperationLabel.text = player1Operations[indexPath.section]![indexPath.row - 1]
                } else {
                    cell.player1OperationLabel.text = "Incomplete"
                }
            }
            
        } else if indexPath.section != 0 && indexPath.row == 5 {
            cell.player0OperationLabel.text = "\(player0Times[indexPath.section]) seconds"
            cell.player0OperationLabel.font = UIFont.boldSystemFontOfSize(14.0)
            cell.player1OperationLabel.text = "\(player1Times[indexPath.section]) seconds"
            cell.player1OperationLabel.font = UIFont.boldSystemFontOfSize(14.0)
        } else {
            if let value = player0Operations[indexPath.section]?.count {
                if value >= indexPath.row + 1 {
                    cell.player0OperationLabel.text = player0Operations[indexPath.section]![indexPath.row]
                } else {
                    cell.player0OperationLabel.text = "Incomplete"
                }
            }
            if let value = player1Operations[indexPath.section]?.count {
                if value >= indexPath.row + 1 {
                    cell.player1OperationLabel.text = player1Operations[indexPath.section]![indexPath.row]
                } else {
                    cell.player1OperationLabel.text = "Incomplete"
                }
            }
        }
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
