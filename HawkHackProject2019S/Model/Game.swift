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
	var timeStamp: Int?
	var player1HP: Int = 100
	var player2HP: Int = 100
	
	var player1Email: String?
	var player2Email: String?
	
	var player1Name: String?
	var player2Name: String?
	
	var player1AvatarUrl: String?
	var player2AvatarUrl: String?
	
	
	static let sharedInstance = Game() //initialize this Game as singleton
	private init() {} //PB ep75 2mins this prevents reinitialization. This prevents us to invoke the ShoppingCart.init(), the access of this class is only through sharedInstance
	
	init(_dictionary: [String: Any]) { //constructor
		self.player1Id = _dictionary[kPLAYER1ID] as? String
		self.text = _dictionary["text"] as? String
		self.player2Id = _dictionary[kPLAYER2ID] as? String
		self.gameId = _dictionary[kGAMESESSIONS] as! String
		
		self.winnerUid = _dictionary[kWINNERUID] as? String
		self.timeStamp = _dictionary["timeStamp"] as? Int
		self.player1HP = _dictionary[kPLAYER1HP] as! Int
		self.player2HP = _dictionary[kPLAYER2HP] as! Int
		
		self.player1Name = _dictionary[kPLAYER1NAME] as? String
		self.player2Name = _dictionary[kPLAYER2NAME] as? String
		
		self.player1Email = _dictionary[kPLAYER1EMAIL] as? String
		self.player2Email = _dictionary[kPLAYER2EMAIL] as? String
		self.player1AvatarUrl = _dictionary[kPLAYER1AVATARURL] as? String
		self.player2AvatarUrl = _dictionary[kPLAYER2AVATARURL] as? String
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
	
	func deleteGame(game: Game, completion: @escaping (_ value: String)-> Void) {
		let player1Ref = firDatabase.child(kUSERTOGAMESESSIONS).child(game.player1Id!).child(game.player2Id!)
		player1Ref.removeValue { (error, ref) in
			if let error = error {
				completion(error.localizedDescription)
			} else {
				print("Successfully removed \(game.gameId)")
//				completion("Success")
			}
		}
		
		let player2Ref = firDatabase.child(kUSERTOGAMESESSIONS).child(game.player2Id!).child(player1Id!)
		player2Ref.removeValue { (error, ref) in
			if let error = error {
				completion(error.localizedDescription)
			} else {
				print("Successfully removed \(game.gameId)")
//				completion("Success")
			}
		}
		
		let userToGameRef = firDatabase.child(kGAMESESSIONS).child(game.gameId)
		userToGameRef.removeValue { (error, ref) in
			if let error = error {
				completion(error.localizedDescription)
			} else {
				print("Successfully removed \(game.gameId)")
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
		self.timeStamp = nil
		self.player1HP = 100
		self.player2HP = 100
		
		self.player1Name = ""
		self.player2Name = ""
	}
	
}


//MARK: Helper fuctions
func fetchGameWith(gameSessionId: String, completion: @escaping (_ game: Game?) -> Void) {
	//	let ref = firDatabase.child(kGAMESESSIONS).queryEqual(toValue: gameSessionId)
	let ref = firDatabase.child(kGAMESESSIONS).child(gameSessionId)
	ref.observe(.value, with: { (snapshot) in
		
		if snapshot.exists() {
			//			print("SNAPSHOT FROM FETCH GAMESESSION IS \(snapshot)")
			//			let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: AnyObject]
			var gameDictionary = snapshot.value as! [String: AnyObject]
			//			print("GAME DICTIONARY IS \(gameDictionary)")
			
			let gameUid: String = gameDictionary[kGAMESESSIONS] as! String
			
			let game = Game(_dictionary: gameDictionary)
			
			//			print("FETCHED GAME IS \(game)")
			completion(game)
		} else { completion(nil) }
	}, withCancel: nil)
}

func uploadCurrentUserSelectedTag(gameSessionId: String, p1OrP2String: String, currentUserTag: (Int?, Int?), completion: @escaping (_ error: Error?) -> Void) {
	let ref = firDatabase.child(kGAMESESSIONS).child(gameSessionId)
	var properties: [String: Int] = [:]
	
	let move:[String:Int] = currentUserTag.0 != nil ? ["\(p1OrP2String)MoveTag": currentUserTag.0!] : ["\(p1OrP2String)MoveTag": 0]
	let attack:[String:Int] = currentUserTag.1 != nil ? ["\(p1OrP2String)AttackTag": currentUserTag.1!] : ["\(p1OrP2String)AttackTag": 0]
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

func fetchOpponentSelectedTag(gameSessionId: String, p1OrP2String: String, completion: @escaping (_ opponentTag: (Int?, Int?)) -> Void) {
	let ref = firDatabase.child(kGAMESESSIONS).child(gameSessionId)
	
	ref.observeSingleEvent(of: .value, with: { (snapshot) in
		
		if snapshot.exists() {
			//			print("SNAPSHOT FROM FETCH opponent user IS \(snapshot)")
			//			let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: AnyObject]
			let resultDic = snapshot.value as! [String: AnyObject]
			let opponentMove = resultDic["\(p1OrP2String)MoveTag"] as! Int
			let opponentAttack = resultDic["\(p1OrP2String)AttackTag"] as! Int
			let opponentMoveTag = opponentMove == 0 ?  nil : opponentMove
			let opponentAttackTag = opponentAttack == 0 ? nil : opponentAttack
//			print("Opponent Tag is \(opponentTag)")
			//			print("USER DICTIONARY IS \(userDictionary)")
//			let user = OpponentUser(_dictionary: userDictionary)
			
			completion((opponentMoveTag, opponentAttackTag))
		} else { completion((nil,nil)) }
		
		
	}, withCancel: nil)
}
