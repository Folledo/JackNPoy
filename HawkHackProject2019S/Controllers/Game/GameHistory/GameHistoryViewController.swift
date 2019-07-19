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
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var losesLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var currentPlayerImageView: UIImageView!
    @IBOutlet weak var gameHistoryTableView: UITableView!
    @IBOutlet weak var profilePicView: UIView!
    
    
//MARK: Properties
    let shapeLayer = CAShapeLayer() //for expBar
    var matches:[Game] = []
    
//MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupViews()
        
        setupGameHistoryTable()
        
    }
    
    func setupGameHistoryTable() {
        
        
        
    }
    
//MARK: Helper Methods
    func setupViews() {
        guard let user = User.currentUser() else { return }
//        print(userDictionaryFrom(user: user))
        fullNameLabel.text = "\(String(describing: user.name))"
        playedIdLabel.text = "\(user.userID)"
        
        currentPlayerImageView.downloaded(fromLink: user.avatarURL)
        currentPlayerImageView.layer.cornerRadius =  75 / 2 //half of the imageView to make it round
        currentPlayerImageView.layer.masksToBounds = true
        
        
        if let wins = user.wins {
            winsLabel.text = "\(String(describing: wins))"
        } else { winsLabel.text = "0" }
        
        if let loses = user.loses {
            losesLabel.text = "\(String(describing: loses))"
        } else { losesLabel.text = "0" }
        
        
        levelLabel.text = "Lvl: \(user.level)"
        
    //experience bar
        let center = currentPlayerImageView.center
        
    //trackLayer
        let trackLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: center, radius: 80/2, startAngle: 0.8 * CGFloat.pi, endAngle: 2.2 * CGFloat.pi, clockwise: true) //path to draw itself, 2 pi
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.lineWidth = 2
        trackLayer.lineCap = CAShapeLayerLineCap.round //kCALineCapRound changed to CAShapeLayerLineCap.round
        profilePicView.layer.addSublayer(trackLayer)
        
    //experience bar layer
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = CAShapeLayerLineCap.round //kCALineCapRound changed to CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        profilePicView.layer.addSublayer(shapeLayer)
        showExperienceBarAnimation()
        
    }
    
    func showExperienceBarAnimation() {
        
    //get the toValue between 0-1 for how "full" our progress bar is
        guard let user = User.currentUser() else { print("no user"); return }
        let currentExp: CGFloat = CGFloat(user.experience)
        let maxExp: CGFloat = CGFloat(getMaxExperienceNeeded(fromLevel: user.level))
        let toValue: CGFloat = currentExp / maxExp
        print("Current user experience is \(currentExp)/\(maxExp)")
        
        
    //create the animation
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = toValue
        basicAnimation.duration = 1 //time in seconds animation
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards //kCAFillModeForwards been replaced by CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
    
//MARK: IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        setupViews()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        
    }
    
    
    
}

extension GameHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "gameHistoryCell", for: indexPath) as! GameHistoryTableViewCell
        //cell.setCellData(game: matches[indexPath]) //need at least matches
        
        return UITableViewCell()
    }
    
    
    
    
}
