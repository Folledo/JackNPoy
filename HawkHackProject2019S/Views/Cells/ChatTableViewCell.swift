//
//  ChatTableViewCell.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
	
	//MARK: IBOutlets
	@IBOutlet weak var header: UILabel!
	@IBOutlet weak var body: UILabel!
	@IBOutlet weak var bubbleView: UIView!
	@IBOutlet weak var avatarImageView: UIImageView!
	
	
	//MARK: LifeCycle
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	//MARK: Public
	func setCellData(message: Message) {
		header.text = message.fullName
		body.text = message.text
		
		avatarImageView.layer.cornerRadius = 25 //half of the imageView to make it round
		avatarImageView.layer.masksToBounds = true
		avatarImageView.downloaded(fromURL: message.avatarURL)
		
		if isUserLoggedIn() {
			if message.userID == User.currentId() {
				bubbleView.backgroundColor = kCOLOR_0E5C89
				body.textColor = .white
				
			} else {
				bubbleView.backgroundColor = .white
				body.textColor = kCOLOR_1B1E1F
			}
		} else {
			bubbleView.backgroundColor = .white
			body.textColor = kCOLOR_1B1E1F
		}
	}
	
	
}
