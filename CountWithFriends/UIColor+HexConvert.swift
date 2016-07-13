//
//  UIColor+HexConvert.swift
//  CountWithFriends
//
//  Created by Paul Lefebvre on 7/12/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

extension UIColor {
    
    
    convenience init(hexString hex: String, alpha: Float = 1.0) {
        
        let characterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet().mutableCopy() as! NSMutableCharacterSet
        
        characterSet.formUnionWithCharacterSet(NSCharacterSet(charactersInString: "#"))
        
        let cString = hex.stringByTrimmingCharactersInSet(characterSet).uppercaseString
        
        if (cString.characters.count != 6) {
            
            self.init(white: 1.0, alpha: 1.0)
            
        } else {
            
            var rgbValue: UInt32 = 0
            
            NSScanner(string: cString).scanHexInt(&rgbValue)
            
            
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      
                      alpha: CGFloat(alpha))
            
        }
        
    }
    
    class func sunsetDark(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"f46b45", alpha: alpha)
    }
    
    class func sunsetLight(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"eea849", alpha: alpha)
    }
    
    class func sunsetText(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"ffc669", alpha: alpha)
    }
    
    class func sunsetOverlay(alpha: Float = 0.75) -> UIColor{
        return UIColor(hexString:"6d1800", alpha: alpha)
    }
    
    class func sunsetOverlayLightText(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"ffca90", alpha: alpha)
    }
    
    class func sunsetOverlayDarkText(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"f28547", alpha: alpha)
    }
    
    class func sunsetDarkText(alpha: Float = 0.49) -> UIColor{
        return UIColor(hexString:"6d1800", alpha: alpha)
    }
    
    class func sunsetBrown(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"803b36", alpha: alpha)
    }
    
    class func midnightDark(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"030207", alpha: alpha)
    }
    
    class func midnightLight(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"1f0d5d", alpha: alpha)
    }
    
    class func midnightOverlay(alpha: Float = 0.75) -> UIColor{
        return UIColor(hexString:"4c2ac1", alpha: alpha)
    }
    
    class func midnightText(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"6e4aeb", alpha: alpha)
    }
    
    class func midnightDarkText(alpha: Float = 0.62) -> UIColor{
        return UIColor(hexString:"4c2ac1", alpha: alpha)
    }
    
    class func emeraldDark(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"0f394c", alpha: alpha)
    }
    
    class func emeraldLight(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"13ad61", alpha: alpha)
    }
    
    class func emeraldText(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"00d97c", alpha: alpha)
    }
    
    class func emeraldDarkText(alpha: Float = 0.62) -> UIColor{
        return UIColor(hexString:"00d97c", alpha: alpha)
    }
    
    class func emeraldOverlay(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"183738", alpha: alpha)
    }
    
    class func onahau(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"#CDFEFF", alpha: alpha)
    }
    
    class func celeste(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"#B0FEFF", alpha: alpha)
    }
    
    class func caribbeanGrean(alpha: Float = 1.0) -> UIColor{
        return UIColor(hexString:"#2DFEA7", alpha: alpha)
    }
    
}