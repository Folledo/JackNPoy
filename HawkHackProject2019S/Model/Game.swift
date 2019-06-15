//
//  Game.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
import FirebaseAuth

class Game {
	
	
	var player1Id: String?
	var text: String?
	var player2Id: String?
	var gameId: String = ""
	
	var winnerUid: String?
//    var timeStamp: Int?
	var player1HP: Int = 100
	var player2HP: Int = 100
	
	var player1Name: String?
	var player2Name: String?
//    var player1Email: String?
//    var player2Email: String?
	
	var player1AvatarUrl: String?
	var player2AvatarUrl: String?
    
    var player1Image: UIImage?
    var player2Image: UIImage?
    
    var roundNumber = 0
	
//    var createdAt: Date?
//    var updatedAt: Date?
    var createdAt: Int?
    var updatedAt: Int?
	
	static let sharedInstance = Game() //initialize this Game as singleton
	private init() {} //PB ep75 2mins this prevents reinitialization. This prevents us to invoke the ShoppingCart.init(), the access of this class is only through sharedInstance
	
	init(_dictionary: [String: Any]) { //constructor
		self.player1Id = _dictionary[kPLAYER1ID] as? String
		self.text = _dictionary["text"] as? String
		self.player2Id = _dictionary[kPLAYER2ID] as? String
		self.gameId = _dictionary[kGAMESESSIONS] as! String
		
		self.winnerUid = _dictionary[kWINNERUID] as? String
//        self.timeStamp = _dictionary[kTIMESTAMP] as? Int
		self.player1HP = _dictionary[kPLAYER1HP] as! Int
		self.player2HP = _dictionary[kPLAYER2HP] as! Int
		
		self.player1Name = _dictionary[kPLAYER1NAME] as? String
		self.player2Name = _dictionary[kPLAYER2NAME] as? String
		
//        self.player1Email = _dictionary[kPLAYER1EMAIL] as? String
//        self.player2Email = _dictionary[kPLAYER2EMAIL] as? String
		self.player1AvatarUrl = _dictionary[kPLAYER1AVATARURL] as? String
		self.player2AvatarUrl = _dictionary[kPLAYER2AVATARURL] as? String
        
//        self.createdAt = dateFormatter().date(from: _dictionary[kCREATEDAT] as! String)!
//        self.updatedAt = dateFormatter().date(from: _dictionary[kUPDATEDAT] as! String)!
        self.createdAt = _dictionary[kCREATEDAT] as? Int
        self.updatedAt = _dictionary[kUPDATEDAT] as? Int
        
        
	}
	
    deinit {
//        print("Game \(self.gameId) is being deinitialized")
    }
	
	internal func gamePartnerId() -> String {
		return (player1Id == User.currentId() ? player2Id : player1Id)!
	}
	
	//	internal func gamePartnerName() -> String {
	//		if player1Id == User.currentId() {
	//			return player2Name
	//		} else {
	//			return player1Name
	//		}
	//	}
	
//    func uploadGameResult(game: Game, winnerUid winningPlayerId: String, completion: @escaping (_ value: String?)-> Void) {
////    func uploadGameResult(completion: @escaping (_ value: String?)-> Void) {
////        let loserPlayerUid: String = (player1Id == winningPlayerId ? player2Id : player1Id)! //if winning playerUID is == p1UID then p2 is loser
//
//    //MARK: These next26 lines basically upload current user's result of the game
//        let userUid = User.currentId()
//        let opponentUid: String = (player1Id == userUid ? player2Id : player1Id)!
//
//        let gameHistoryRef = firDatabase.child(kGAMEHISTORY).child(userUid)
//        let userRef = firDatabase.child(kUSERS).child(userUid)
//
//        if userUid == winnerUid { //if currentUser won...
//        //set the result in gameHistory
//            gameHistoryRef.setValue(["result": "winner", "opponentUid": opponentUid, "date": Date()]) { (error, ref) in
//                if let error = error {
//                    completion(error.localizedDescription)
//                } else {
//                    print("Finished saving the win")
//                    completion(nil)
//                }
//            }
//
//        //grab the user's win, exp, level and update it
//            userRef.observeSingleEvent(of: .value, with: { (snap) in
//
//                if snap.exists() {
//                    guard let userDic = snap.value as? NSDictionary else { print("No userDic found"); return }
//                    var wins = userDic[kWINS] as? Int ?? 0
//                    var experience = userDic[kEXPERIENCE] as? Int ?? 0
//
//                    userRef.updateChildValues([kWINS: wins += 1, kEXPERIENCE: experience += 100], withCompletionBlock: { (error, ref) in
//                        if let error = error {
//                            completion(error.localizedDescription)
//                        } else {
//                            print("Successfully updated wins stats and experience in firebase")
//                        }
//                    })
//                }
//
//            }, withCancel: nil)
//
//        } else { //if currentUser lose
//            gameHistoryRef.setValue(["result": "loser", "opponentUid": opponentUid, "date": Date()]) { (error, ref) in
//                if let error = error {
//                    completion(error.localizedDescription)
//                } else {
//                    print("Finished saving the lose)")
//                    completion(nil)
//                }
//            }
//
//        //grab the user's lose, exp, level and update it
//            userRef.observeSingleEvent(of: .value, with: { (snap) in
//                if snap.exists() {
//                    guard let userDic = snap.value as? NSDictionary else { print("No userDic found"); return }
//                    var loses = userDic[kLOSES] as? Int ?? 0
//                    var experience = userDic[kEXPERIENCE] as? Int ?? 0
//
//                    userRef.updateChildValues([kWINS: loses += 1, kEXPERIENCE: experience += 50], withCompletionBlock: { (error, ref) in
//                        if let error = error {
//                            completion(error.localizedDescription)
//                        } else {
//                            print("Successfully updated lose stats and experience in firebase")
//                        }
//                    })
//                }
//            }, withCancel: nil)
//        }
//    }
    
	func deleteGame(game: Game, completion: @escaping (_ value: String)-> Void) {
		let player1Ref = firDatabase.child(kUSERTOGAMESESSIONS).child(game.player1Id!).child(game.player2Id!)
		player1Ref.removeValue { (error, ref) in
			if let error = error {
				completion(error.localizedDescription)
			} else {
				print("Successfully removed \(game.gameId) from P1")
//				completion("Success")
			}
		}
		
		let player2Ref = firDatabase.child(kUSERTOGAMESESSIONS).child(game.player2Id!).child(player1Id!)
		player2Ref.removeValue { (error, ref) in
			if let error = error {
				completion(error.localizedDescription)
			} else {
				print("Successfully removed \(game.gameId) from P2")
//				completion("Success")
			}
		}
		
		let userToGameRef = firDatabase.child(kGAMESESSIONS).child(game.gameId)
		userToGameRef.removeValue { (error, ref) in
			if let error = error {
				completion(error.localizedDescription)
			} else {
				print("Successfully removed \(game.gameId) from userToGame reference")
//				completion("Success")
			}
		}
		completion("Success")
	}
	
	internal func reset() {
		self.player2Id = nil
		self.player1Id = nil
		self.text = nil
		self.gameId = ""
		
		self.winnerUid = nil
//        self.timeStamp = nil
		self.player1HP = 100
		self.player2HP = 100
		
		self.player1Name = ""
		self.player2Name = ""
//        self.player1Email = ""
//        self.player2Email = ""
	}
//--------------------------------------+++++++++++++++++++++++++++++++++++
    
//    class func currentGameRoundNumber(game: Game) {
//        let ref = firDatabase.child(kGAMESESSIONS).child(game.gameId).child(kTURNCOUNT)
//        ref.observeSingleValue
//    }
    
}

//+++++++++++++++++++++++++   MARK: Saving user   ++++++++++++++++++++++++++++++++++
//func saveGameInBackground(game: Game) {
//
//    let ref = firDatabase.child(kGAMESESSIONS).child(game.gameId)
//
//    let ref = firDatabase.child(kUSERS).child(user.userID)
//    ref.setValue(userDictionaryFrom(user: user))
//    print("Finished saving user \(user.name) in Firebase")
//}

//save locally
//func saveUserLocally(user: User) {
//    UserDefaults.standard.set(userDictionaryFrom(user: user), forKey: kCURRENTUSER)
//    UserDefaults.standard.synchronize()
//    print("Finished saving user \(user.name) locally...")
//}





//MARK: Helper fuctions
//func fetchUserWith(userId: String, completion: @escaping (_ user: User?) -> Void) {
//    //    print("1")
//    //    let ref = firDatabase.child(kGAMESESSIONS).queryEqual(toValue: gameSessionId)
//    let ref = firDatabase.child(kUSERS).child(kUSERID)
//    //    print("2")
//    ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//        //        print("3")
//        //        print("EYO SNAPSHot\(snapshot)")
//        if snapshot.exists() {
//            print("SNAPSHOT FROM FETCH USERWITH IS \(snapshot)")
//            //            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: AnyObject]
//            let userDictionary = snapshot.value as! [String: AnyObject]
//            let user = User(_dictionary: userDictionary)
//            print("FETCHED USER IS \(user)")
//            completion(user)
//        } else { completion(nil) }
//
//
//    }, withCancel: nil)
//    //    ref.observeSingleEvent(of: .value, with: { (snapshot) in
//    //
//    //    }, withCancel: nil)
//}
//func fetchUserWith(userId: String, completion: @escaping (_ user: User?) -> Void) {
//    let ref = firDatabase.child(kUSERS).queryOrdered(byChild: kUSERID).queryEqual(toValue: userId)
//
//    ref.observeSingleEvent(of: .value, with: { (snapshot) in
//        print("SNAPSHOT FROM FETCH USER IS \(snapshot)")
//        if snapshot.exists() {
//            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: Any]
//            let user = User(_dictionary: userDictionary)
//            completion(user)
//        } else { completion(nil) }
//    }, withCancel: nil)
//}


//func userDictionaryFrom(user: User) -> NSDictionary { //take a user and return an NSDictionary
//
//    return NSDictionary(
//        objects: [user.userID, user.name, user.email, user.avatarURL],
//        forKeys: [kUSERID as NSCopying, kNAME as NSCopying, kEMAIL as NSCopying, kAVATARURL as NSCopying]) //this func create and return an NSDictionary
//}


//func updateCurrentUser(withValues: [String : Any], withBlock: @escaping(_ success: Bool) -> Void) {
//
//    if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
//        guard let currentUser = User.currentUser() else { return }
//        let userObject = userDictionaryFrom(user: currentUser).mutableCopy() as! NSMutableDictionary
//        userObject.setValuesForKeys(withValues)
//
//        let ref = firDatabase.child(kUSERS).child(currentUser.userID)
//        ref.updateChildValues(withValues) { (error, ref) in
//            if error != nil {
//                withBlock(false)
//                return
//            }
//
//            UserDefaults.standard.set(userObject, forKey: kCURRENTUSER)
//            UserDefaults.standard.synchronize()
//            withBlock(true)
//        }
//    }
//
//}

//func isUserLoggedIn() -> Bool {
//    if User.currentUser() != nil {
//        return true
//    } else {
//        return false
//    }
//}

//---------------------------------++++++++++++++++++++++++++++++++++++++++++++++++

//MARK: Helper fuctions
func uploadGameResult(game: Game, completion: @escaping (_ value: String?)-> Void) {
    print("uploadGameResult is now being ran")
    //    func uploadGameResult(completion: @escaping (_ value: String?)-> Void) {
    //        let loserPlayerUid: String = (player1Id == winningPlayerId ? player2Id : player1Id)! //if winning playerUID is == p1UID then p2 is loser
    
    //MARK: These next26 lines basically upload current user's result of the game
    let userUid = User.currentId()
    let opponentUid: String = (game.player1Id == userUid ? game.player2Id : game.player1Id)!
    
    let gameHistoryRef = firDatabase.child(kGAMEHISTORY).child(userUid).child(game.gameId)
    let userRef = firDatabase.child(kUSERS).child(userUid).child(kGAMESTATS)//NOW WORK ON PULLING WINNER/LOSER, EXPERIENCE, AND LEVEL
    
    if userUid == game.winnerUid { //if currentUser won...
        //set the result in gameHistory
        gameHistoryRef.setValue(["result": "winner", "opponentUid": opponentUid]) { (error, ref) in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                print("Finished saving the win")
//                completion(nil)
            }
        }
        
        
//grab the user's win, exp, level and update it
        userRef.observeSingleEvent(of: .value, with: { (snap) in
            
//            if snap.exists() {
            print("\n\ngame result Snap is \(snap)\n\n")
//                guard let userDic = snap.value as? NSDictionary else { print("No userDic found")
            
            if let userDic = snap.value as? NSDictionary {
                print("User dic in uploadGameResult = \(userDic)")
                let wins = userDic[kWINS] as? Int ?? 0
                let experience = userDic[kEXPERIENCE] as? Int ?? 0
                
                userRef.updateChildValues([kWINS: wins + 1, kEXPERIENCE: experience + 100], withCompletionBlock: { (error, ref) in //LOOKING FOR KEXPERIENCE
                    if let error = error {
                        completion(error.localizedDescription)
                    } else {
                        print("Successfully updated wins stats and experience in firebase")
                    }
                })
            } else {
                userRef.setValue([kWINS: 1, kEXPERIENCE: 100], withCompletionBlock: { (error, ref) in
                    print("This is first game ever, should only be printed once")
                    
                    if let error = error {
                        completion(error.localizedDescription)
                        
                    } else {
                        print("First game completed with a win!")
                        
                    }
                })
            }
        }, withCancel: nil)
        
    } else { //if userUid != game.winnerUid, meaning currentUser lose
        print("current user lost")
        gameHistoryRef.setValue(["result": "loser", "opponentUid": opponentUid]) { (error, ref) in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                print("Finished saving the lose)")
                ////                completion(nil)
                //            }
                //        }
                //
            } //end of no error on setting value on gameHistory
        } //end of gameHistory.setValue
        
        //        //grab the user's lose, exp, level and update it
        userRef.observeSingleEvent(of: .value, with: { (snap) in
            //            if snap.exists() {
            //                guard let userDic = snap.value as? NSDictionary else { print("No userDic found"); return }
            if let userDic = snap.value as? NSDictionary {
                let loses = userDic[kLOSES] as? Int ?? 0
                let experience = userDic[kEXPERIENCE] as? Int ?? 0
                
                userRef.updateChildValues([kLOSES: loses + 1, kEXPERIENCE: experience + 10], withCompletionBlock: { (error, ref) in
                    if let error = error {
                        completion(error.localizedDescription)
                    } else {
                        print("Successfully updated lose stats and experience in firebase")
                    }
                })
                
            } else {
                userRef.setValue([kLOSES: 1, kEXPERIENCE: 10], withCompletionBlock: { (error, ref) in
                    print("This is first game ever, should only be printed once")
                    
                    if let error = error {
                        completion(error.localizedDescription)
//                        return
                    } else {
                        print("First game completed with a LOSE!")
                        
                    }
                })
            } //end of user's 1st fighting game ever
        }, withCancel: nil) //end of userRef.observeSingleEvent
        
    } //end of if currentUser lose
    
    print("No error at all!!!")
    completion(nil)
}


func fetchGameWith(gameSessionId: String, completion: @escaping (_ game: Game?) -> Void) { //used in PreGameVC
	//	let ref = firDatabase.child(kGAMESESSIONS).queryEqual(toValue: gameSessionId)
    let ref =  firDatabase.child(kGAMESESSIONS).child(gameSessionId)
    
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
        
        if snapshot.exists() {
            //            print("SNAPSHOT FROM FETCH GAMESESSION IS \(snapshot)")
            //            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: AnyObject]
            var gameDictionary = snapshot.value as! [String: AnyObject]
            //            print("GAME DICTIONARY IS \(gameDictionary)")
            
            //            let gameUid: String = gameDictionary[kGAMESESSIONS] as! String
            
            let game = Game(_dictionary: gameDictionary)
            
            //            print("FETCHED GAME IS \(game)")
            completion(game)
        } else {
            print("ref doesn't exist")
            completion(nil) }
    }, withCancel: nil)
}


func gameDictionaryFrom(game: Game) -> NSDictionary {
    return NSDictionary(objects:[game.gameId, game.roundNumber], forKeys:[] )
}


func uploadCurrentUserSelectedTag(gameSessionId: String, p1OrP2String: String, turnCount: Int, currentUserTag: (Int?, Int?), completion: @escaping (_ error: Error?) -> Void) {
    let ref =  firDatabase.child(kGAMESESSIONS).child(gameSessionId).child(kCURRENTGAME).child(kROUNDS).child("\(turnCount)")

	var properties: [String: Int] = [:]
	
    
    let move = currentUserTag.0 == nil ? ["\(p1OrP2String)MoveTag": 1] : ["\(p1OrP2String)MoveTag": currentUserTag.0]
    let attack = currentUserTag.1 == nil ? ["\(p1OrP2String)MoveTag": 1] : ["\(p1OrP2String)AttackTag": currentUserTag.1]
    
	move.forEach {properties[$0] = $1}
	attack.forEach {properties[$0] = $1}
	ref.updateChildValues(properties) { (error, ref) in
		if let error = error {
			completion(error)
		} else {
			print("\(p1OrP2String)MoveTag was successfully uploaded")
			completion(nil)
		}
	}
}

func fetchOpponentSelectedTag(gameSessionId: String, p1OrP2String: String, turnCount: Int, completion: @escaping (_ opponentTag: (Int?, Int?)) -> Void) { //used in PreGameVC
    let ref =  firDatabase.child(kGAMESESSIONS).child(gameSessionId).child(kCURRENTGAME).child(kROUNDS).child("\(turnCount)")

	
    ref.observe(.value, with: { (snapshot) in
        print("Hey something was added at currentGame turn #\(turnCount)")
		if snapshot.exists() {
            print("1")
			//			print("SNAPSHOT FROM FETCH opponent user IS \(snapshot)")
			//			let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: AnyObject]
            print("SNAPSHOT is \(snapshot)")
            guard let resultDic = snapshot.value as? [String: AnyObject] else {
//                completion((0,0))
                print("2")
                return
            }
            print("Result Dic is \(resultDic)")
            guard let opponentMove = resultDic["\(p1OrP2String)MoveTag"] as? Int else { print("No opponentMove found"); return }
            guard let opponentAttack = resultDic["\(p1OrP2String)AttackTag"] as? Int else { print("No opponentAttack found"); return }
//            let opponentMoveTag = opponentMove == 0 ?  nil : opponentMove
//            let opponentAttackTag = opponentAttack == 0 ? nil : opponentAttack
//			print("Opponent Tag is \(opponentTag)")
			//			print("USER DICTIONARY IS \(userDictionary)")
//			let user = OpponentUser(_dictionary: userDictionary)
			
			completion((opponentMove, opponentAttack))
		} else { completion((nil,nil)) }
		
		
	}, withCancel: nil)
}

//date object and function
private let dateFormat = "yyyyMMddHHmmss" //RE ep.12 3mins made it private so it will remain constant and wont be changed at all outside of this file
func dateFormatter() -> DateFormatter { //RE ep.12 1min DateFormatter = A formatter that converts between dates and their textual representations.
    let dateFormatter = DateFormatter() //RE ep.12 2mins
    dateFormatter.dateFormat = dateFormat //RE ep.12 3mins
    
    return dateFormatter //RE ep.12 4mins
}
