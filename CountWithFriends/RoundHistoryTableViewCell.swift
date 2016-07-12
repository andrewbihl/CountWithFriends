//
//  RoundHistoryTableViewCell.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 7/7/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class RoundHistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var player0OperationLabel: UILabel!
    @IBOutlet weak var player1OperationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
