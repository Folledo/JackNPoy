//
//  Message.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation

class Message {
	
	var userID: String = ""
	var fullName: String
	var avatarURL: URL
	var text: String
	
	
	init(_userID: String, _fullName: String, _avatarURL: URL, _text: String) {
		userID = _userID
		fullName = _fullName
		avatarURL = _avatarURL
		text = _text
	}
	
	init(_dictionary: [String: Any]) {
		userID = _dictionary[kUSERID] as! String //crash it if message has no userID
		fullName = _dictionary[kNAME] as! String
		avatarURL = URL(string: _dictionary[kAVATARURL] as? String ?? "")! //avatarURL or ""
		text = _dictionary[kTEXT] as! String
	}
	
	init(testName name: String, withTestMessage message: String) {
		userID = "0"
		fullName = name
		avatarURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Smiley.svg/220px-Smiley.svg.png")!
		text = message
	}
	
	
	
}

