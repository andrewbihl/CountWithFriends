//
//  GameCollectionViewCell.swift
//  CountWithFriends
//
//  Created by joy on 7/8/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet weak var roundNumberLabel: UILabel!
    var programmaticLabel : UILabel?
    
    override func awakeFromNib() {
        label.numberOfLines = 2
        label.textColor = UIColor.whiteColor()
        roundNumberLabel.textColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.darkSpringGreen(0.7)
        addShadow(self, opacity: 0.5, radius: 0.5)
    }
    
    func addShadow(shadowView: UIView, opacity: Float, radius: CGFloat) {
        shadowView.layer.shadowColor = UIColor.blackColor().CGColor
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowOffset = CGSizeZero
        shadowView.layer.shadowRadius = radius
    }
}
