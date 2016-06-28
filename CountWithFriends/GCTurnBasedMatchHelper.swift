//
//  GCTurnBasedMatchHelper.swift
//  CountWithFriends
//
//  Created by Andrew Bihl on 6/28/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit
import GameKit

protocol GCTurnBasedMatchHelperDelegate {
    func attemptGameCenterLogin(loginView: UIViewController)
}

class GCTurnBasedMatchHelper: NSObject {
    static let sharedInstance = GCTurnBasedMatchHelper()
    //var gameCenterAvailable: Bool?
    var userAuthenticated = false
    var delegate : GCTurnBasedMatchHelperDelegate?
    
    override init(){
        super.init()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(authenticationChanged), name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }
    
    func authenticationChanged(){
        if GKLocalPlayer.localPlayer().authenticated && !userAuthenticated{
            print("Authentication changed: user now authenticated")
            userAuthenticated = true
        } else if GKLocalPlayer.localPlayer().authenticated && userAuthenticated{
            print("Authentication changed: user no longer authenticated")
            userAuthenticated = false
        }
    }
    
    func authenticateLocalUser(){
        print("Authenticating user...")
        if !GKLocalPlayer.localPlayer().authenticated{
            GKLocalPlayer.localPlayer().authenticateHandler = {(viewController : UIViewController?, error : NSError?) -> () in
                if viewController != nil{
                    print("Should have presented view controller")
                    self.delegate?.attemptGameCenterLogin(viewController!)
                }
                else if error != nil{
                    print("Whoops. Error in authentication: \(error!)")
                }
                else{
                    print("Should be logged in now.")
                }
            }
        }else{
            print("Already authenticated.")
        }
    }
    
}
