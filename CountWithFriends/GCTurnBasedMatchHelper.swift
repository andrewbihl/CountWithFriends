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
    func didJoinOrCreateMatch(match:GKTurnBasedMatch)
}

class GCTurnBasedMatchHelper: NSObject {
    static let sharedInstance = GCTurnBasedMatchHelper()
    var menuViewController : UIViewController?
    var userAuthenticated = false
    var delegate : GCTurnBasedMatchHelperDelegate?
    var myMatch : GKTurnBasedMatch?
    
    override init(){
        super.init()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: #selector(authenticationChanged), name: GKPlayerAuthenticationDidChangeNotificationName, object: nil)
    }

    func joinOrStartRandomGame(){
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        request.defaultNumberOfPlayers = 2
        
        GKTurnBasedMatch.findMatchForRequest(request) { (match: GKTurnBasedMatch?, error: NSError?) in
            if error != nil{
                print("Error in searching for game match: \(error)")
            }
            else if match != nil{
                self.myMatch = match!
                if match?.participants?[1].player == nil {
                    print("Created a new match")
                }else{
                    print("Found a match!")
                }

                let playerNameAsData = NSData(base64EncodedString: "TEST", options: .IgnoreUnknownCharacters)
                match?.saveCurrentTurnWithMatchData(NSData(), completionHandler: { (error: NSError?) in
                    if error != nil{
                        print("Error in saving data: \(error)")
                    } else{
                        match?.endTurnWithNextParticipants((match!.participants)!, turnTimeout: 3600, matchData: playerNameAsData!, completionHandler: { (error: NSError?) in
                            if error != nil{
                                print("WHAT THE FUCKK")
                            }else{
                                
                                self.delegate?.didJoinOrCreateMatch(self.myMatch!)
                            }
                        })
                    }
                })
                
            }
        }
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
                    print("MY ID IS: \(GKLocalPlayer.localPlayer().displayName!)")
                }
            }
        }else{
            print("Already authenticated.")
        }
    }
    
}
