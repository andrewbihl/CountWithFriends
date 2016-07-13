//
//  GameButton.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 7/12/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

class GameButton: UIButton {
    override var enabled: Bool{
        didSet(previousState){
            print(previousState)
            if previousState != false{
                if gradient != nil{
                    self.gradient?.removeFromSuperlayer()
                }
                
                self.backgroundColor = UIColor.lightGrayColor()
            } else{
                setGradient()
            }
        }
    }
    var gradient: CAGradientLayer?

    override var bounds: CGRect {
        didSet {
            setGradient()
        }
    }
    
    override var frame: CGRect {
        didSet {
            setGradient()
        }
    }
    
    func setGradient() {
        if gradient != nil {
            self.gradient!.removeFromSuperlayer()
        }
        
        gradient = CAGradientLayer()
        gradient!.cornerRadius = 5
        gradient!.frame = self.bounds
        
        gradient!.colors = [UIColor.caribbeanGrean().CGColor,UIColor.emeraldLight().CGColor]
        
        /* repeat the central location to have solid colors */
        gradient!.locations = [0,1.0]
        
        /* make it horizontal */
        gradient!.startPoint = CGPointMake(0, 0)
        gradient!.endPoint = CGPointMake(1, 1)
        
        self.layer.insertSublayer(gradient!, atIndex: 0)
    }

}
