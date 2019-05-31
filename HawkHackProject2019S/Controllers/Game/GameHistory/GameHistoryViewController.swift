//
//  GameHistoryViewController.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 5/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class GameHistoryViewController: UIViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var playedIdLabel: UILabel!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var currentPlayerImageView: UIImageView!
    
    @IBOutlet weak var gameHistoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupViews()
        
    }
    
    func setupViews() {
        fullNameLabel.text = "\(String(describing: User.currentUser()!.name))"
        playedIdLabel.text = "\(User.currentId())"
        currentPlayerImageView.downloaded(fromLink: User.currentUser()!.avatarURL)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
    }
    
    
    
}
