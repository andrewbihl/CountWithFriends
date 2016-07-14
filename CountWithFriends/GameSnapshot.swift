//
//  gameSnapshot.swift
//  CountWithFriends
//
//  Created by Andrew Bihl on 7/13/16.
//  Copyright © 2016 Andrew Bihl. All rights reserved.
//

import UIKit

//This is a snapshot unique to the player, so the information differs for the same match depending on who is seeing it.
class GameSnapshot: NSObject {
    var matchID = ""
    var yourName = ""
    var opponentName = ""
    var yourScore = 0
    var opponentScore = 0
    var currentRound = 0
}
