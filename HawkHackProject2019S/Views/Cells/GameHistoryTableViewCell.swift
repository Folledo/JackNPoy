//
//  GameHistoryTableViewCell.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 5/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class GameHistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var opponentImageView: UIImageView!
    
    @IBOutlet weak var opponentNameLabel: UILabel!
    @IBOutlet weak var gameDateLabel: UILabel!
    
    @IBOutlet weak var gameCoinsLabel: UILabel!
    @IBOutlet weak var gameExpLabel: UILabel!
    @IBOutlet weak var gameHPLabel: UILabel!
    @IBOutlet weak var gameResultButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(game: Game) {
        if game.player1Id == User.currentId() { //if p1 is our current user then opponent is p2
            let opponentUid: String = game.player2Id!
            fetchOpponentUserWith(opponentUid: opponentUid) { (opponentUser) in
                self.opponentImageView.downloaded(fromLink: opponentUser!.avatarURL)
                self.opponentNameLabel.text = "\(opponentUser!.name)"
            }
            
        } else { //current user is p2
            let opponentUid: String = game.player1Id!
            fetchOpponentUserWith(opponentUid: opponentUid) { (opponentUser) in
                self.opponentImageView.downloaded(fromLink: opponentUser!.avatarURL)
                self.opponentNameLabel.text = "\(opponentUser!.name)"
            }
        }
//        let opponentUid: String = (game.player1Id == User.currentId() ? game.player2Id : game.player1Id)! //opponentUid will not be the current user
        
        
    }

}
