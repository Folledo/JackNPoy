//
//  Constants.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

let kUSERID: String = "userID"
let kNAME: String = "name"
let kEMAIL: String = "email"
let kAVATARURL: String = "avatarURL"
let kTEXT: String = "text"
let kCURRENTUSER: String = "currentUser" //for userDefaults
let kUSERS: String = "user" //fore firebase
let kMESSAGES: String = "message"

let kGAMESESSIONS: String = "gameSessions"
let kUSERTOGAMESESSIONS: String = "user-gameSessions"
let kPLAYER1ID: String = "player1Id"
let kPLAYER2ID: String = "player2Id"
let kPLAYER1NAME: String = "player1Name"
let kPLAYER2NAME: String = "player2Name"
let kPLAYER1EMAIL: String = "player1Email"
let kPLAYER2EMAIL: String = "player2Email"
let kPLAYER1AVATARURL: String = "player1AvatarUrl"
let kPLAYER2AVATARURL: String = "player2AvatarUrl"
let kPLAYER1IMAGE: String = "player1Image"
let kPLAYER2IMAGE: String = "player2Image"
let kPLAYER1HP: String = "player1Hp"
let kPLAYER2HP: String = "player2Hp"
let kP1MOVE: String = "p1Move"
let kP2MOVE: String = "p2Move"
let kCREATEDAT: String = "createdAt"
let kUPDATEDAT: String = "updatedAt"

let kWINNERUID: String = "winnerUid"
let kCURRENTGAME: String = "currentGame"
let kGAMEATTACK: String = "gameAttack"
let kGAMEMOVE: String = "gameMove"
let kMOVES: String = "moves"
let kTURNCOUNT: String = "turnCount"
let kROUNDNUMBER: String = "roundNumber"
let kROUNDS: String = "rounds"
let kGAMEID: String = "gameId"
let kTIMESTAMP: String = "timeStamp"
let kGAMEHISTORY: String = "gameHistory"
//let kTURNCOUNTER: String = "turnCounter"

//storyboard VC Identifiers
let kHOMEVIEWCONTROLLER: String = "homeVC"
let kPREGAMEVIEWCONTROLLER: String = "preGameVC"
let kGAMEVIEWCONTROLLER: String = "gameVC"
let kGAMEOVERVIEWCONTROLLER: String = "gameOverVC"
let kGAMEHISTORYVIEWCONTROLLER: String = "gameHistoryVC"
let kGAMEHISTORYCELL: String = "gameHistoryCell"

//User info
let kGAMESTATS: String = "gameStats" //this is for Firebase/users/uid/gameStats
let kWINLOSESTAT: String = "winLoseStat"
let kWINS: String = "wins"
let kLOSES: String = "loses"
let kMATCHESUID: String = "matchesUid"
let kMATCHESDICTIONARY: String = "matchesDictionary"
let kEXPERIENCES: String = "experiences"
let kMAXEXPERIENCE: String = "maxExperience"
let kLEVEL: String = "level"
let kRESULT: String = "result"
let kOPPONENTUID: String = "opponentUid"


let kSMILEYURL: String = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Smiley.svg/220px-Smiley.svg.png"
let firDatabase = Database.database().reference()


//colors
let kCOLOR_FFFFFF: UIColor = UIColor(rgb: 0xFFFFFF)
let kCOLOR_1B1E1F: UIColor = UIColor(rgb: 0x1B1E1F)
let kCOLOR_5F6063: UIColor = UIColor(rgb: 0x5F6063)
let kCOLOR_0E5C89: UIColor = UIColor(rgb: 0x0E5C89)
let kCOLOR_F9F9F9: UIColor = UIColor(rgb: 0xF9F9F9)

let kREDCGCOLOR = UIColor.red.cgColor
let kCLEARCGCOLOR = UIColor.clear.cgColor
let kGREENCGCOLOR = UIColor.green.cgColor


//fonts
let kHEADERTEXT: UIFont = UIFont.systemFont(ofSize: 17, weight: .semibold)


//controller storyboard id
let kCHATCONTROLLER: String = "chatController"
let kLOGINCONTROLLER: String = "loginController"
let kANIMATIONCONTROLLER: String = "animationController"
let kMENUCONTROLLER: String = "menuController"
