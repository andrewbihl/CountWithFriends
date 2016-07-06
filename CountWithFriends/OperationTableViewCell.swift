//
//  OperationTableViewCell.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 6/29/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

protocol OperationTableViewCellDelegate: class {
    func didRemoveOperation(sender: OperationTableViewCell)
    func didUseOutput(sender: OperationTableViewCell, button: UIButton)
}

class OperationTableViewCell: UITableViewCell {

    @IBOutlet weak var firstOperandLabel: UILabel!
    @IBOutlet weak var secondOperandLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var outputValueButton: UIButton!
    @IBOutlet weak var removeRowButton: UIButton!
    @IBOutlet weak var equalLabel: UILabel!
    
    var delegate: OperationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        removeRowButton.layer.borderColor = UIColor(red: 81/255, green: 159/255, blue: 243/255, alpha: 1).CGColor
        removeRowButton.layer.borderWidth = 1
        removeRowButton.layer.cornerRadius = 15
        
        outputValueButton.layer.borderColor = UIColor(red: 81/255, green: 159/255, blue: 243/255, alpha: 1).CGColor
        outputValueButton.layer.borderWidth = 1
        outputValueButton.layer.cornerRadius = 5
        //outputValueButton.titleEdgeInsets = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onOutputValueTapped(sender: UIButton) {
        delegate?.didUseOutput(self, button: sender)
    }
    @IBAction func onRemoveRowButtonTapped(sender: AnyObject) {
        delegate?.didRemoveOperation(self)
    }

}
