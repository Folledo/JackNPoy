//
//  GameHistoryViewController.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 5/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class GameHistoryViewController: UIViewController {
    
//MARK: IBOutlets
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var playedIdLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var currentPlayerImageView: UIImageView!
    @IBOutlet weak var gameHistoryTableView: UITableView!
    
    
//MARK: Properties
    
    
//MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupViews()
        
    }
    
//MARK: Helper Methods
    func setupViews() {
        guard let user = User.currentUser() else { return }
        fullNameLabel.text = "\(String(describing: user.name))"
        playedIdLabel.text = "\(user.userID)"
        currentPlayerImageView.downloaded(fromLink: user.avatarURL)
        
        statsLabel.text = "\(user.wins)-\(user.loses)"
        levelLabel.text = "\(user.level)"
        
    }
    
//MARK: IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
    }
    
    
    
}
