//
//  User.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth


class User: NSObject {
	var name: String
	var email: String
	var avatarURL: String
	var userID: String
    
//    var winLoseStat: [Int: Int] //win/lose
    var wins: Int?
    var loses: Int?
    var matchesDictionary: [String]? //has info like "winnerUid": String, "wonBy" Int
    var matchesUid: [String]?
    var experience: Int
    var level: Int
	
    init(_userID: String, _name: String, _email: String, _avatarURL: String = "", _wins: Int, _loses: Int, _matchesDictionary: [String], _matchesUid: [String], _experience: Int, _level: Int) {
		userID = _userID
		name = _name
		email = _email
		avatarURL = _avatarURL
        
        wins = _wins
        loses = _loses
        matchesDictionary = _matchesDictionary
        matchesUid = _matchesUid
        experience = _experience
        level = _level
	}
    
//to initialize user easier
    init(_userID: String, _name: String, _email: String, _avatarURL: String = "", _experience: Int, _level: Int) {
        userID = _userID
        name = _name
        email = _email
        avatarURL = _avatarURL
        
        experience = _experience
        level = _level
    }
	
	init(_dictionary: [String: Any]) {
		self.name = _dictionary[kNAME] as! String
		self.email = _dictionary[kEMAIL] as! String
		self.avatarURL = _dictionary[kAVATARURL] as! String
		self.userID = _dictionary[kUSERID] as! String
        
    //user Informations
//        self.winLoseStat = _dictionary[kWINLOSESTAT] as! [Int: Int]
        self.wins = _dictionary[kWINS] as? Int
        self.loses = _dictionary[kLOSES] as? Int
        self.matchesUid = _dictionary[kMATCHESUID] as? [String] ?? [""]
        self.matchesDictionary = _dictionary[kMATCHESDICTIONARY] as? [String] ?? [""]
        self.experience = (_dictionary[kEXPERIENCES] as? Int)!
        self.level = _dictionary[kLEVEL] as! Int
	}
	
    deinit {
//        print("User \(self.name) is being deinitialize.")
    }
    
	class func currentId() -> String {
		return Auth.auth().currentUser!.uid
	}
    
//    class func currentEmail() -> String {
//        return (Auth.auth().currentUser?.email)!
//    }
	
	class func currentUser() -> User? {
		if Auth.auth().currentUser != nil { //if we have user...
			if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
				return User.init(_dictionary: dictionary as! [String: Any])
			}
		}
		return nil //if we dont have user in our UserDefaults, then return nil
	}
	
	
	class func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
		Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
			if let error = error {
				completion(error)
				return
			}
			
			completion(error)
		}
	}
	
	class func loginUserWith(email: String, password: String, withBlock: @escaping (_ error: Error?) -> Void) {
		Auth.auth().signIn(withEmail: email, password: password) { (firUser, error) in
			if let error = error {
				withBlock(error)
				return
			}
			//RE ep.110 3mins
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { //it is important to have some DELAY
				let uid: String = firUser!.user.uid
				fetchUserWith(userId: uid, completion: { (user) in
					guard let user = user else { print("no user"); return }
					saveUserLocally(user: user) //since fetchUserWith already calls saveUserInBackground
					withBlock(error)
				})
			})
		}
	}
	
	
	//MARK: Logout
	class func logOutCurrentUser(withBlock: (_ success: Bool) -> Void) {
		print("Logging outttt...")
		UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
		UserDefaults.standard.synchronize() //save the changes
		
		do {
			try Auth.auth().signOut()
			withBlock(true)
		} catch let error as NSError {
			print("error logging out \(error.localizedDescription)")
			withBlock(false)
		}
	}
	
	
	class func deleteUser(completion: @escaping(_ error: Error?) -> Void) { //delete the current user
		let user = Auth.auth().currentUser
		user?.delete(completion: { (error) in
			completion(error)
		})
	}
    
//    class func increaseExperience(amount: Int) {
//        if Auth.auth().currentUser != nil {
//
//        }
//    }
    
	
}

//+++++++++++++++++++++++++   MARK: Saving user   ++++++++++++++++++++++++++++++++++
func saveUserInBackground(user: User) {
	let ref = firDatabase.child(kUSERS).child(user.userID)
	ref.setValue(userDictionaryFrom(user: user))
	print("Finished saving user \(user.name) in Firebase")
    
    
}

//save locally
func saveUserLocally(user: User) {
	UserDefaults.standard.set(userDictionaryFrom(user: user), forKey: kCURRENTUSER)
	UserDefaults.standard.synchronize()
	print("Finished saving user \(user.name) locally...")
}

func increaseExperience(user: User, gained: Int, completion: @escaping () -> Void) {
    user.experience += gained
    let maxExp:Int = getMaxExperienceNeeded(fromLevel: user.level)
    print("Experience = \(user.experience)/\(maxExp)")
    if user.experience >= maxExp { //check if our user has more experience than maxExp
        print("LEVEL UP! Has extra exp = \(user.experience - maxExp)")
        increaseUserLevel(user: user, extra: user.experience - maxExp) {
            completion()
        }
    } else {
        completion()
    }
//    saveUserLocally(user: user)
//    saveUserInBackground(user: user)
}

func increaseUserLevel(user: User, extra exp: Int, completion: @escaping () -> Void) {
    let extraExperience: Int = exp
    user.level += 1
    user.experience = 0
    user.experience = extraExperience > 0 ? extraExperience : 0
    completion()
//    saveUserLocally(user: user)
//    saveUserInBackground(user: user)
}

//MARK: Helper fuctions
//func fetchUserWith(userId: String, completion: @escaping (_ user: User?) -> Void) {
//	//	print("1")
//	//	let ref = firDatabase.child(kGAMESESSIONS).queryEqual(toValue: gameSessionId)
//	let ref = firDatabase.child(kUSERS).child(kUSERID)
//	//	print("2")
//	ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//		//		print("3")
//		//		print("EYO SNAPSHot\(snapshot)")
//		if snapshot.exists() {
//			print("SNAPSHOT FROM FETCH USERWITH IS \(snapshot)")
//			//			let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: AnyObject]
//			let userDictionary = snapshot.value as! [String: AnyObject]
//			let user = User(_dictionary: userDictionary)
//			print("FETCHED USER IS \(user)")
//			completion(user)
//		} else { completion(nil) }
//
//
//	}, withCancel: nil)
//	//	ref.observeSingleEvent(of: .value, with: { (snapshot) in
//	//
//	//	}, withCancel: nil)
//}
func fetchUserWith(userId: String, completion: @escaping (_ user: User?) -> Void) {
	let ref = firDatabase.child(kUSERS).queryOrdered(byChild: kUSERID).queryEqual(toValue: userId)

	ref.observeSingleEvent(of: .value, with: { (snapshot) in
//        print("SNAPSHOT FROM FETCH USER IS \(snapshot)")
		if snapshot.exists() {
			let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: Any]
			let user = User(_dictionary: userDictionary)
			completion(user)
		} else { completion(nil) }
	}, withCancel: nil)
}


func userDictionaryFrom(user: User) -> NSDictionary { //take a user and return an NSDictionary
	
	return NSDictionary(
        objects: [user.userID, user.name, user.email, user.avatarURL, user.wins!, user.loses!, user.matchesDictionary ?? [""], user.matchesUid ?? [""], user.experience, user.level],
        forKeys: [kUSERID as NSCopying, kNAME as NSCopying, kEMAIL as NSCopying, kAVATARURL as NSCopying, kWINS as NSCopying, kLOSES as NSCopying, kMATCHESDICTIONARY as NSCopying, kMATCHESUID as NSCopying, kEXPERIENCES as NSCopying, kLEVEL as NSCopying]) //this func create and return an NSDictionary
}


func updateCurrentUser(withValues: [String : Any], withBlock: @escaping(_ success: Bool) -> Void) {
	
	if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil {
		guard let currentUser = User.currentUser() else { return }
		let userObject = userDictionaryFrom(user: currentUser).mutableCopy() as! NSMutableDictionary
		userObject.setValuesForKeys(withValues)
		
		let ref = firDatabase.child(kUSERS).child(currentUser.userID)
		ref.updateChildValues(withValues) { (error, ref) in
			if error != nil {
				withBlock(false)
				return
			}
			
			UserDefaults.standard.set(userObject, forKey: kCURRENTUSER)
			UserDefaults.standard.synchronize()
			withBlock(true)
		}
	}
	
}

func isUserLoggedIn() -> Bool {
	if User.currentUser() != nil {
		return true
	} else {
		return false
	}
}


func getMaxExperienceNeeded(fromLevel level: Int) -> Int {
    var num: Int = 100
    switch level {
    case 0:
        print("Current level is 0, or maybe lower")
        return num
    case _ where level > 0:
        print("You are level \(level)")
        num = (level * (level / 2)) * 100
    default:
        break
    }
    return num
}


//func isUserLoggedIn(viewController: UIViewController) -> Bool {
//
//	if User.currentUser() != nil {
//		return true
//	} else {
//		let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: kLOGINCONTROLLER) as! LoginViewController
//		viewController.present(vc, animated: true, completion: nil)
//		return false
//	}
//}
