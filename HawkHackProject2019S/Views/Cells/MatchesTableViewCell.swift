//
//  MatchesTableViewCell.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class MatchesTableViewCell: UITableViewCell {
	
	//MARK: IBOutlets
	@IBOutlet weak var opponentImageView: UIImageView!
	@IBOutlet weak var opponentNameLabel: UILabel!
	@IBOutlet weak var acceptButton: UIButton!
	@IBOutlet weak var declineButton: UIButton!
	@IBOutlet weak var resultButton: UIButton!
	
	//MARK: Properties
	var delegate: MatchesTableViewCellDelegate!
	var gameUid: String!
	var match: Game?
	var indexPath: IndexPath?
	
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
	func setCellData(game: Game) {
		self.gameUid = game.gameId
		self.match = game
		
		opponentImageView.layer.cornerRadius = 25 //half of the imageView to make it round
		opponentImageView.layer.masksToBounds = true
		
		if game.player1Id == User.currentId() { //then dont put player1Id as the opponentName
			opponentNameLabel.text = game.player2Name
//            opponentImageView.image = game.player2Image
            opponentImageView.downloaded(fromLink: game.player2AvatarUrl!)
			self.declineButton.setTitle("Cancel", for: .normal)
		} else {
			opponentNameLabel.text = game.player1Name
//            opponentImageView.image = game.player1Image
            opponentImageView.downloaded(fromLink: game.player1AvatarUrl!)
		}
		
	}
	
	@IBAction func acceptButtonTapped(_ sender: Any) {
		if self.delegate != nil {
            
            
            
			self.delegate.segueWithGameUid(withGame: match!)
		}
	}
	@IBAction func declineButtonTapped(_ sender: Any) {
		print("Decline \(gameUid!)")
		if self.delegate != nil {
			self.delegate.removeGame(withGame: match!, indexPath: self.indexPath!)
		}
	}
	
}
