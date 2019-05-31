//
//  GameOverViewController.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 5/14/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var experienceGainedLabel: UILabel!
    @IBOutlet weak var coinsGainedLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    var didWin: Bool?
//    {
//        didSet {
//            if let won = didWin {
//                print("won has value")
//                self.backgroundImageView.image = won == true ? UIImage(named: "youWin.jpg") : UIImage(named: "youLose.png")
//            }
//        }
//    }
    
    var game: Game?
    var opponentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let won = didWin {
            print("won has value")
            self.backgroundImageView.image = won == true ? UIImage(named: "youWin.jpg") : UIImage(named: "youLose.png")
        }
        
        self.profileImageView.layer.cornerRadius = 25 //half of the imageView to make it round
        self.profileImageView.layer.masksToBounds = true
        self.profileImageView.downloaded(fromLink: "\(String(describing: User.currentUser()?.avatarURL))")
        
        self.navigationController?.isNavigationBarHidden = true //hide nav controller
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func noButtonTapped(_ sender: Any) {
        let preGameVC: PreGameViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: kPREGAMEVIEWCONTROLLER) as! PreGameViewController
        self.navigationController?.popToViewController(preGameVC, animated: true)
//        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func yesButtonTapped(_ sender: Any) {
        
        let userId = User.currentId()
//        let opponentUid = userId == game!.player1Id ? game!.player2Id : game!.player1Id //opponentUid if currentUserId is == p1Id, then opponentUid is p2Id, else p1Id
//        
//        fetchOpponentUserWith(opponentUid: opponentUid!) { (opponentUser) in
//            
//        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
