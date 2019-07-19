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
        guard let user = User.currentUser() else { return }
        let opponentUid: String = User.currentId() == game.player1Id ? game.player2Id! : game.player1Id! //if user is p1, then opponent is p2
        switch game.winnerUid {
        case user.userID:
            gameCoinsLabel.text = "+$10"
            gameExpLabel.text = "+100"
            gameResultButton.setBackgroundImage(UIImage(named: "W"), for: .normal)
        case opponentUid:
            gameCoinsLabel.text = "+$1"
            gameExpLabel.text = "+10"
            gameResultButton.setBackgroundImage(UIImage(named: "L"), for: .normal)
        default:
            print("Weird game uid = \(game.winnerUid)\ndoes not match any user uid")
        }
        
        fetchOpponentUserWith(opponentUid: opponentUid) { (opponentUser) in
            self.opponentImageView.downloaded(fromLink: opponentUser!.avatarURL)
            self.opponentNameLabel.text = "\(opponentUser!.name)"
            
        }

//        if game.player1Id == User.currentId() { //if p1 is our current user then opponent is p2
//            let opponentUid: String = User.currentId() == game.player1Id ? game.player2Id! : game.player1Id!
//            fetchOpponentUserWith(opponentUid: opponentUid) { (opponentUser) in
//                self.opponentImageView.downloaded(fromLink: opponentUser!.avatarURL)
//                self.opponentNameLabel.text = "\(opponentUser!.name)"
//            }
//
//        } else { //current user is p2
//            let opponentUid: String = game.player1Id!
//            fetchOpponentUserWith(opponentUid: opponentUid) { (opponentUser) in
//                self.opponentImageView.downloaded(fromLink: opponentUser!.avatarURL)
//                self.opponentNameLabel.text = "\(opponentUser!.name)"
//            }
//        }
//        let opponentUid: String = (game.player1Id == User.currentId() ? game.player2Id : game.player1Id)! //opponentUid will not be the current user
        
        
    }

}
