//
//  GameButton.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 7/12/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class GameButton: UIButton {
    var gradient: CAGradientLayer?
    var isOperand = false;
    override var bounds: CGRect {
        didSet {
            if gradient != nil {
                self.gradient!.removeFromSuperlayer()
            }
            
            gradient = CAGradientLayer()
            gradient!.cornerRadius = 5
            gradient!.frame = self.bounds
            
            gradient!.colors = setColors()
            
            /* repeat the central location to have solid colors */
            gradient!.locations = [0,1.0]
            
            /* make it horizontal */
            gradient!.startPoint = CGPointMake(0, 0)
            gradient!.endPoint = CGPointMake(1, 1)
            
            self.layer.insertSublayer(gradient!, atIndex: 0)
        }
    }
    
    func setColors() -> [CGColor] {
        if isOperand {
            return [UIColor.caribbeanGrean().CGColor,UIColor.emeraldLight().CGColor]
        } else {
            return [UIColor.onahau().CGColor,UIColor.celeste().CGColor]
        }
        
    }

}
