//
//  CurrentGameViewController.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 4/1/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

struct RyuAnimationName {
	static let Standing = ("ryu", 6) //because frames only goes from 0-5
	static let Jump = ("ryuJumpPunch", 32)
	static let Kick = ("", 0)
	static let Punch = ("ryuJumpPunch", 32)
}

struct ButtonAnimations {
	static let None = ("", 0)
	static let SmallFire = ("smallFire", 23)
	static let BigFire = ("bigFire", 15)
}

class CurrentGameViewController: UIViewController {
	
//MARK: IBOutlets
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var gameSessionLabel: UILabel!
	@IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var roundNumberLabel: UILabel!
	
	@IBOutlet weak var player1NameLabel: UILabel!
	@IBOutlet weak var player1ImageView: UIImageView!
	@IBOutlet weak var player1HPLabel: UILabel!
	@IBOutlet weak var player1DamageLabel: UILabel!
	@IBOutlet weak var player1Character: UIImageView!
	@IBOutlet weak var player1MovesView: MyView!
	@IBOutlet weak var player1HPBar: UIProgressView!
	
	@IBOutlet weak var player2NameLabel: UILabel!
	@IBOutlet weak var player2ImageView: UIImageView!
	@IBOutlet weak var player2HPLabel: UILabel!
	@IBOutlet weak var player2DamageLabel: UILabel!
	@IBOutlet weak var player2Character: UIImageView!
	@IBOutlet weak var player2MovesView: MyView!
	@IBOutlet weak var player2HPBar: UIProgressView!
	
	@IBOutlet weak var p1Button10Up: MovesButton!
	@IBOutlet weak var p1Button11Back: MovesButton!
	@IBOutlet weak var p1Button12Down: MovesButton!
	@IBOutlet weak var p1Button13Forward: MovesButton!
	@IBOutlet weak var p1Button14LUp: MovesButton!
	@IBOutlet weak var p1Button15MUp: MovesButton!
	@IBOutlet weak var p1Button16HUp: MovesButton!
	@IBOutlet weak var p1Button17LDown: MovesButton!
	@IBOutlet weak var p1Button18MDown: MovesButton!
	@IBOutlet weak var p1Button19HDown: MovesButton!
	
	@IBOutlet weak var p1Button14ImageView: UIImageView!
	@IBOutlet weak var p1Button15ImageView: UIImageView!
	@IBOutlet weak var p1Button16ImageView: UIImageView!
	@IBOutlet weak var p1Button17ImageView: UIImageView!
	@IBOutlet weak var p1Button18ImageView: UIImageView!
	@IBOutlet weak var p1Button19ImageView: UIImageView!
	
	
	@IBOutlet weak var p2Button20Up: MovesButton!
	@IBOutlet weak var p2Button21Forward: MovesButton!
	@IBOutlet weak var p2Button22Down: MovesButton!
	@IBOutlet weak var p2Button23Back: MovesButton!
	@IBOutlet weak var p2Button24HUp: MovesButton!
	@IBOutlet weak var p2Button25MUp: MovesButton!
	@IBOutlet weak var p2Button26LUp: MovesButton!
	@IBOutlet weak var p2Button27HDown: MovesButton!
	@IBOutlet weak var p2Button28MDown: MovesButton!
	@IBOutlet weak var p2Button29LDown: MovesButton!
	
	@IBOutlet weak var p2Button24ImageView: UIImageView!
	@IBOutlet weak var p2Button25ImageView: UIImageView!
	@IBOutlet weak var p2Button26ImageView: UIImageView!
	@IBOutlet weak var p2Button27ImageView: UIImageView!
	@IBOutlet weak var p2Button28ImageView: UIImageView!
	@IBOutlet weak var p2Button29ImageView: UIImageView!
	
	
//MARK: Properties
	var game: Game?
	
	var player1TagSelected: (move: Int?, attack: Int?)
	var player2TagSelected: (move: Int?, attack: Int?)
	
	var p1MoveResult: (damage: Int?, damageMultiplier: CGFloat?, defenseMultiplier: CGFloat?, speed: CGFloat?)
	var p2MoveResult: (damage: Int?, damageMultiplier: CGFloat?, defenseMultiplier: CGFloat?, speed: CGFloat?)
	
	var player1MoveButtons: [MovesButton]?
	var player1AttackButtons: [MovesButton]?
	var player2MoveButtons: [MovesButton]?
	var player2AttackButtons: [MovesButton]?
	var allButtons: [MovesButton]?
	
	var kenCounter = 0
	var kenTimer: Timer?
	
	var ryuImageName = RyuAnimationName.Standing
	var ryuCounter = 0
	var ryuTimer: Timer?
	
	var backgroundCounter = 0
	var bgMaxCounter: Int = 0
	var backgroundTimer: Timer?
	var backgroundName: String = ""
	var player1Hp: Int = 100
	var player2Hp: Int = 100
	
	var clockTimer: Timer?
	var clockCounter: Int = 8
	var turnCount: Int = 0
	
	let player1HPProgress = Progress(totalUnitCount: 100)
	let player2HPProgress = Progress(totalUnitCount: 100)
	
	var smallFireTimer: Timer?
	var smallFireCounter = 0
	var bigFireTimer: Timer?
	var bigFireCounter = 0
	
	var isAgainstOnlineUser: Bool = false
    var p1HasSpeedBoost = false
    var fetchingOpponentMoveTimer: Timer?
	
//MARK: LifeCycle -----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		setupPlayersButtons()
		
		setupBackgroundImageView()
		
		player1HPBar.transform = CGAffineTransform(scaleX: -1, y: 1)
		player2HPBar.transform = CGAffineTransform(scaleX: -1, y: 1)
		player1HPBar.transform = player1HPBar.transform.scaledBy(x: 1, y: 10)
		player2HPBar.transform = player2HPBar.transform.scaledBy(x: 1, y: 10)
		
		
		
		
		updateViewWithGame(currentGame: game!)
		
		
        turnCount = 1
        self.roundNumberLabel.text = "\(turnCount)"
		startTurnTimer()
    }
    
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		backgroundTimer?.invalidate()
		clockTimer?.invalidate()
		ryuTimer?.invalidate()
		kenTimer?.invalidate()
        fetchingOpponentMoveTimer?.invalidate()
	}
	
	private func putAnimation(button: MovesButton, animation: (String,Int)) {
//		if button.cooldown > 1 { return }
		var images: [UIImage] = []
		var duration: Double = 0
		button.animation = animation
		if button.animation == ButtonAnimations.None {
			duration = 0
			button.damageMultiplier = 1
		} else if button.animation == ButtonAnimations.SmallFire {
			duration = 2.3
			button.damageMultiplier *= 1.5
			for i in 0 ... ButtonAnimations.SmallFire.1 {
				images.append(UIImage(named: "\(ButtonAnimations.SmallFire.0)\(i)")!)
			}
		} else if button.animation == ButtonAnimations.BigFire {
			duration = 1.5
			button.damageMultiplier *= 2.0
			for i in 0 ... ButtonAnimations.BigFire.1 {
				images.append(UIImage(named: "\(ButtonAnimations.BigFire.0)\(i)")!)
			}
		} else { print("weird button animations") }
		
		switch button {
		case p1Button14LUp:
			p1Button14ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p1Button15MUp:
			p1Button15ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p1Button16HUp:
			p1Button16ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p1Button17LDown:
			p1Button17ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p1Button18MDown:
			p1Button18ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p1Button19HDown:
			p1Button19ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p2Button24HUp:
			p2Button24ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p2Button25MUp:
			p2Button25ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p2Button26LUp:
			p2Button26ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p2Button27HDown:
			p2Button27ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p2Button28MDown:
			p2Button28ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		case p2Button29LDown:
			p2Button29ImageView.image = UIImage.animatedImage(with: images, duration: duration)
		default:
			break
		}
		
//		button.setBackgroundImage(UIImage.animatedImage(with: images, duration: duration), for: .normal)
	}
	
	
//MARK: Private methods -----------------------------------------------------
	private func setupPlayersButtons() {
		player1MoveButtons = [p1Button10Up, p1Button11Back, p1Button12Down, p1Button13Forward]
		player1AttackButtons = [p1Button14LUp, p1Button15MUp, p1Button16HUp, p1Button17LDown, p1Button18MDown, p1Button19HDown]
		
		player2MoveButtons = [p2Button20Up, p2Button21Forward, p2Button22Down, p2Button23Back]
		player2AttackButtons = [p2Button24HUp, p2Button25MUp, p2Button26LUp, p2Button27HDown, p2Button28MDown, p2Button29LDown]
		
		self.allButtons = (player1MoveButtons! + player1AttackButtons! + player2MoveButtons! + player2AttackButtons!)
		
		p1Button10Up.buttonTag = 10
		p1Button11Back.buttonTag = 11
		p1Button12Down.buttonTag = 12
		p1Button13Forward.buttonTag = 13
		
		p1Button14LUp.buttonTag = 14
		p1Button14LUp.damage = 10
		
		p1Button15MUp.buttonTag = 15
		p1Button15MUp.damage = 15
		
		p1Button16HUp.buttonTag = 16
		p1Button16HUp.damage = 20
		
		p1Button17LDown.buttonTag = 17
		p1Button17LDown.damage = 10
		
		p1Button18MDown.buttonTag = 18
		p1Button18MDown.damage = 15
		
		p1Button19HDown.buttonTag = 19
		p1Button19HDown.damage = 20
		
		p2Button20Up.buttonTag = 20
		p2Button21Forward.buttonTag = 21
		p2Button22Down.buttonTag = 22
		p2Button23Back.buttonTag = 23
		
		p2Button24HUp.buttonTag = 24
		p2Button24HUp.damage = 20
		
		p2Button25MUp.buttonTag = 25
		p2Button25MUp.damage = 15
		
		p2Button26LUp.buttonTag = 26
		p2Button26LUp.damage = 10
		
		p2Button27HDown.buttonTag = 27
		p2Button27HDown.damage = 20
		
		p2Button28MDown.buttonTag = 28
		p2Button28MDown.damage = 15
		
		p2Button29LDown.buttonTag = 29
		p2Button29LDown.damage = 10
	}
	
	private func startTurnTimer() {
//        turnCount = 1
//        self.roundNumberLabel.text = "\(turnCount)"
        
        if p1HasSpeedBoost {
            p1MoveResult = (damage:0, damageMultiplier:CGFloat(1), defenseMultiplier:CGFloat(1), speed: CGFloat(1)) //give p1MoveResults a +1 speed boost
            p2MoveResult = (damage:0, damageMultiplier:1, defenseMultiplier:1, speed:0)
        } else {
            p2MoveResult = (damage:0, damageMultiplier:CGFloat(1), defenseMultiplier:CGFloat(1), speed: CGFloat(1)) //give p2 +1 speed boost
            p1MoveResult = (damage:0, damageMultiplier:1, defenseMultiplier:1, speed:0)
        }
        
        
		clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTurnTime), userInfo: nil, repeats: true)
	}
	
    
    
    
    
	
	/////////////////////////////////////////////////////////
    private func setupSelectedTag() {
//        p1MoveResult = (damage:0, damageMultiplier:1, defenseMultiplier:1, speed:0)
//        p2MoveResult = (damage:0, damageMultiplier:1, defenseMultiplier:1, speed:0)
        player1MovesView.isUserInteractionEnabled = false
        player2MovesView.isUserInteractionEnabled = false
        
        if !isAgainstOnlineUser {
            applyDamagesToViews(opponentTag: (nil,nil)) {
                print("Done updating turn")
                self.finishTurn()
            }
            return
        } else { //if we are playing against someone online...
            if User.currentId() == self.game?.player1Id { //if our current user is p1 then upload p1's selectedTag and fetch p2's selectedTag
                self.player1TagSelected.move = player1TagSelected.move == nil ? 1 : player1TagSelected.move
                self.player1TagSelected.attack = player1TagSelected.attack == nil ? 1 : player1TagSelected.attack //ifuser didnt select a move, we will upload 1 instead of the buttonTag
                
                uploadCurrentUserSelectedTag(gameSessionId: game!.gameId, p1OrP2String: "p1", turnCount: turnCount, currentUserTag: (player1TagSelected.move!, player1TagSelected.attack!)) { (error) in //we can safely force unwrap tagSelected because we said to equal it to 1 if it is nil
                    if let error = error {
                        Service.presentAlert(on: self, title: "Error Uploading User Selected Tag", message: error.localizedDescription)
                        return
                    } else {
                        self.fetchOpponentSelectedTag(gameSessionId: self.game!.gameId, p1OrP2String: "p2", turnCount: self.turnCount)
                    }
                }
            } else if User.currentId() == self.game?.player2Id { //if our current user is p2 then upload p2's selectedTag and fetch p1's selectedTag
                self.player2TagSelected.move = player2TagSelected.move == nil ? 1 : player2TagSelected.move //if user didnt select a move, we will upload 1 instead of the buttonTag
                self.player2TagSelected.attack = player2TagSelected.attack == nil ? 1 : player2TagSelected.attack //ifuser didnt select a move, we will upload 1 instead of the buttonTag
                
                uploadCurrentUserSelectedTag(gameSessionId: game!.gameId, p1OrP2String: "p2", turnCount: turnCount, currentUserTag: (player2TagSelected.move!, player2TagSelected.attack!)) { (error) in
                    if let error = error {
                        Service.presentAlert(on: self, title: "Error Uploading User Selected Tag", message: error.localizedDescription)
                        return
                    } else {
                        self.fetchOpponentSelectedTag(gameSessionId: self.game!.gameId, p1OrP2String: "p1", turnCount: self.turnCount)
                    }
                }
            }
        }
    }
    
    
    func fetchOpponentSelectedTag(gameSessionId: String, p1OrP2String: String, turnCount: Int) {
        let ref =  firDatabase.child(kGAMESESSIONS).child(gameSessionId).child("currentGame").child("\(turnCount)")
        ref.observe(.value, with: { (snapshot) in
            print("Hey something was added at currentGame turn #\(turnCount)")
            if snapshot.exists() && snapshot.childrenCount == 4 { //if it exist and it has 4 children (p1Move, p1Attack, p2Move, p2Attack)...
                self.fetchingOpponentMoveTimer?.invalidate()
                //            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! [String: AnyObject]
                print("SNAPSHOT is \(snapshot)")
                guard let resultDic = snapshot.value as? [String: AnyObject] else {
                    //                completion((0,0))
                    print("2")
                    return
                }
                print("Result Dic is \(resultDic)")
                guard let fetchedOpponentMove = resultDic["\(p1OrP2String)MoveTag"] as? Int else {
                    print("No opponentMove found");
                    return
                }
                guard let fetchedOpponentAttack = resultDic["\(p1OrP2String)AttackTag"] as? Int else { print("No opponentAttack found"); return }
                
                
                if p1OrP2String == "p1" {
                    self.player1TagSelected = (fetchedOpponentMove, fetchedOpponentAttack)
                    for button in self.player1AttackButtons! where self.player1TagSelected.attack == button.buttonTag {
                        button.selectedButton = true
                    }
                    for button in self.player1MoveButtons! where self.player1TagSelected.move == button.buttonTag {
                        button.selectedButton = true
                    }
                    
                } else {
                    self.player2TagSelected = (fetchedOpponentMove, fetchedOpponentAttack)
                    for button in self.player2AttackButtons! where self.player2TagSelected.attack == button.buttonTag {
                        button.selectedButton = true
                    }
                    for button in self.player2MoveButtons! where self.player2TagSelected.move == button.buttonTag {
                        button.selectedButton = true
                    }
                }
                
                print("applying damage to views")
                self.applyDamagesToViews(opponentTag: (fetchedOpponentMove, fetchedOpponentAttack)) {
                    print("applied damage to views")
                    if self.player1TagSelected == (nil, nil) || self.player2TagSelected == (nil, nil) {
                        print("Player1 or Player 2 Tag is nil")
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.finishTurn()
                        }
                    }
                }
            } else { //snapshot dont exist or not all 4 moves are available
                self.player1MovesView.isUserInteractionEnabled = false
                self.player2MovesView.isUserInteractionEnabled = false
                self.scheduledTimerWithTimeInterval()
            }
            
            
        }, withCancel: nil)
    }
    
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        fetchingOpponentMoveTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
    }
    @objc func updateCounting() {
        print("counting...")
    }
	
    private func applyDamagesToViews(opponentTag:(move: Int?, attack: Int?), completion: @escaping () -> Void) { //or () -> ()
//		print("p1: \(player1TagSelected)")
//		print("p2: \(player2TagSelected)")
        
//        if isAgainstOnlineUser { //if we are against another player ONLINE
//
//
//            getPlayer1Damage()
//            getPlayer2Damage()
//            getEnemyDefense()
//
//            ryuCounter = 0
//
//            let player1Damage = Int(CGFloat(p1MoveResult.damage!) * p1MoveResult.damageMultiplier! * p2MoveResult.defenseMultiplier!)
//            let player2Damage = Int(CGFloat(p2MoveResult.damage!) * p2MoveResult.damageMultiplier! * p1MoveResult.defenseMultiplier!)
//
//            print("P1 Damage = \(player1Damage)\nP2 Damage = \(player2Damage)")
//
//            //        print("P1 \(p1MoveResult)\nP2 \(p2MoveResult)")
//
//
//            if player1Damage > 0 {
//                player2DamageLabel.text = "-\(player1Damage)"
//                player2DamageLabel.isHidden = false
//                player2DamageLabel.pulsate()
//            }
//            if player2Damage > 0 {
//                player1DamageLabel.text = "-\(player2Damage)"
//                player1DamageLabel.isHidden = false
//                player1DamageLabel.pulsate()
//            }
//
//
//            if CGFloat(p1MoveResult.speed!) > CGFloat(p2MoveResult.speed!) { //if p1 first
//                //            print("p1 first")
//                self.player2Hp -= player1Damage
//                self.player2HPProgress.completedUnitCount += Int64(player1Damage)
//                let player2ProgressFloat = Float(self.player2HPProgress.fractionCompleted)
//                self.player2HPBar.setProgress(player2ProgressFloat, animated: true)
//
//
//                if player2Hp > 0 { //if p2 is still alive
//                    self.player1Hp -= player2Damage
//                    self.player1HPProgress.completedUnitCount += Int64(player2Damage)
//                    let player1ProgressFloat = Float(self.player1HPProgress.fractionCompleted)
//                    self.player1HPBar.setProgress(player1ProgressFloat, animated: true)
//                    self.player1HPLabel.text = "\(player1Hp)/100"
//                    self.player2HPLabel.text = "\(player2Hp)/100"
//                } else { //if p2 dies
//                    self.player1HPLabel.text = "WIN!"
//                    self.player2HPLabel.text = "LOSE"
//                    return
//                }
//
//            } else { //if p2 first
//                //            print("p2 first")
//                self.player1Hp -= player2Damage
//                self.player1HPProgress.completedUnitCount += Int64(player2Damage)
//                let player1ProgressFloat = Float(self.player1HPProgress.fractionCompleted)
//                self.player1HPBar.setProgress(player1ProgressFloat, animated: true)
//
//                if player1Hp > 0 { //if p1 is still alive
//                    self.player2Hp -= player1Damage
//                    self.player2HPProgress.completedUnitCount += Int64(player1Damage)
//                    let player2ProgressFloat = Float(self.player2HPProgress.fractionCompleted)
//                    self.player2HPBar.setProgress(player2ProgressFloat, animated: true)
//                    self.player1HPLabel.text = "\(player1Hp)/100"
//                    self.player2HPLabel.text = "\(player2Hp)/100"
//                } else { //if p1 dies
//                    self.player1HPLabel.text = "LOSE"
//                    self.player2HPLabel.text = "WIN!"
//                    return
//                }
//
//            }
//
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { //delay
//                self.player1DamageLabel.isHidden = true
//                self.player2DamageLabel.isHidden = true
//                completion()
//            })
//
//
//
//
////if we are against another user in the same phone
//        } else {
            getPlayer1Damage()
            getPlayer2Damage()
            getEnemyDefense()
            
            ryuCounter = 0
            
            var player1Damage = Int(CGFloat(p1MoveResult.damage!) * p1MoveResult.damageMultiplier! * p2MoveResult.defenseMultiplier!)
            var player2Damage = Int(CGFloat(p2MoveResult.damage!) * p2MoveResult.damageMultiplier! * p1MoveResult.defenseMultiplier!)
            
//            print("P1 Damage = \(player1Damage)\nP2 Damage = \(player2Damage)")
//            print("P1 speed = \(p1MoveResult.speed)\nP2 speed = \(p2MoveResult.speed)")
            //        print("P1 \(p1MoveResult)\nP2 \(p2MoveResult)")
            
            
            if player1Damage > 0 {
                player2DamageLabel.text = "-\(player1Damage)"
                player2DamageLabel.isHidden = false
                player2DamageLabel.pulsate()
            }
            if player2Damage > 0 {
                player1DamageLabel.text = "-\(player2Damage)"
                player1DamageLabel.isHidden = false
                player1DamageLabel.pulsate()
            }
            
            
            if CGFloat(p1MoveResult.speed!) > CGFloat(p2MoveResult.speed!) { //if p1 first
                //            print("p1 first")
                self.player2Hp -= player1Damage
                self.player2HPProgress.completedUnitCount += Int64(player1Damage)
                let player2ProgressFloat = Float(self.player2HPProgress.fractionCompleted)
                self.player2HPBar.setProgress(player2ProgressFloat, animated: true)
                
                p1HasSpeedBoost = true //set it to true so we can give p1 a +1 speed for next turn
                player2Damage = Int(CGFloat(player2Damage) * 0.9) //gives a little incentive to go first by reducing damage received by 10% if a player moves first
                
                if player2Hp > 0 { //if p2 is still alive
                    self.player1Hp -= player2Damage
                    self.player1HPProgress.completedUnitCount += Int64(player2Damage)
                    let player1ProgressFloat = Float(self.player1HPProgress.fractionCompleted)
                    self.player1HPBar.setProgress(player1ProgressFloat, animated: true)
                    
                    if player1Hp <= 0 { //if p1 dies
                        print("p2 wins")
                        self.player1HPLabel.text = "LOSE"
                        self.player2HPLabel.text = "WIN"
                        return
                    } else {
                        self.player1HPLabel.text = "\(player1Hp)/100"
                        self.player2HPLabel.text = "\(player2Hp)/100"
                    }
                } else { //if p2 dies
                    print("p1 wins")
                    self.player1HPLabel.text = "WIN!"
                    self.player2HPLabel.text = "LOSE"
                    return
                }
                
            } else { //if p2 first
                //            print("p2 first")
                self.player1Hp -= player2Damage
                self.player1HPProgress.completedUnitCount += Int64(player2Damage)
                let player1ProgressFloat = Float(self.player1HPProgress.fractionCompleted)
                self.player1HPBar.setProgress(player1ProgressFloat, animated: true)
                
                p1HasSpeedBoost = false //p2 will have +1 speed boost
                player1Damage = Int(CGFloat(player1Damage) * 0.9)
                
                if player1Hp > 0 { //if p1 is still alive
                    self.player2Hp -= player1Damage
                    self.player2HPProgress.completedUnitCount += Int64(player1Damage)
                    let player2ProgressFloat = Float(self.player2HPProgress.fractionCompleted)
                    self.player2HPBar.setProgress(player2ProgressFloat, animated: true)
                    
                    if player2Hp <= 0 { //if p2 dies
                        print("p1 wins")
                        self.player1HPLabel.text = "WIN!"
                        self.player2HPLabel.text = "LOSE"
                        return
                    } else {
                        self.player1HPLabel.text = "\(player1Hp)/100"
                        self.player2HPLabel.text = "\(player2Hp)/100"
                    }
                    
                } else { //if p1 dies
                    print("p2 wins")
                    self.player1HPLabel.text = "LOSE"
                    self.player2HPLabel.text = "WIN!"
                    return
                }
                
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { //delay
                self.player1DamageLabel.isHidden = true
                self.player2DamageLabel.isHidden = true
                completion()
            })
//        }
	}
	
	
	private func getPlayer1Damage() {
		var player1Damage: CGFloat = 0
		
		
		
		switch player1TagSelected.attack {
		case (14): //p1 Light Up
			ryuImageName = RyuAnimationName.Jump
			player1Damage = CGFloat(p1Button14LUp.damage) * p1Button14LUp.damageMultiplier
			
			p1Button14LUp.cooldown = 2
			p1MoveResult.speed! += 9
			
		case (15): //p1 Medium Up
			player1Damage = CGFloat(p1Button15MUp.damage) * p1Button15MUp.damageMultiplier
			p1Button15MUp.cooldown = 3
			p1MoveResult.speed! += 6
			
		case (16): //p1 Heavy Up
			player1Damage = CGFloat(p1Button16HUp.damage) * p1Button16HUp.damageMultiplier
			p1Button16HUp.cooldown = 4
			
			p1MoveResult.speed! += 3
			
		case (17): //p1 Light Down
			player1Damage = CGFloat(p1Button17LDown.damage) * p1Button17LDown.damageMultiplier
			
			p1Button17LDown.cooldown = 2
			p1MoveResult.speed! += 9
			
			
		case (18): //p1 Medium Down
			player1Damage = CGFloat(p1Button18MDown.damage) * p1Button18MDown.damageMultiplier
			
			p1Button18MDown.cooldown = 3
			p1MoveResult.speed! += 6
			
				
		case (19): //p1 Heavy Down
			player1Damage = CGFloat(p1Button19HDown.damage) * p1Button19HDown.damageMultiplier
			
			p1Button19HDown.cooldown = 4
			p1MoveResult.speed! += 3
			
		case .none:
			player1Damage = 0
		default:
			break
		}
		
		for button in player1MoveButtons! where button.selectedButton == true { //put p1 move on cooldown
			button.cooldown = 2
		}
		
		p1MoveResult.damage = Int(player1Damage)
//        print("player 1 damage = \(p1MoveResult.damage)")
	}
	

	private func getPlayer2Damage() {
		var player2Damage: CGFloat = 0
		
		switch player2TagSelected.attack {
		case (24): //p2 Heavy Up
			player2Damage = CGFloat(p2Button24HUp.damage) * p2Button24HUp.damageMultiplier
			p2Button24HUp.cooldown = 4
			p2MoveResult.speed! += 3
			
		case (25): //p2 Medium Up
			player2Damage = CGFloat(p2Button25MUp.damage) * p2Button25MUp.damageMultiplier
			p2Button25MUp.cooldown = 3
			p2MoveResult.speed! += 6
			
			
		case (26): //p2 Light Up
			player2Damage = CGFloat(p2Button26LUp.damage) * p2Button26LUp.damageMultiplier
			p2Button26LUp.cooldown = 2
			p2MoveResult.speed! += 9
			
		case (27): //p2 Heavy Down
			player2Damage = CGFloat(p2Button27HDown.damage) * p2Button27HDown.damageMultiplier
			p2Button27HDown.cooldown = 4
			p2MoveResult.speed! += 3
			
		case (28): //p2 Medium Down
			player2Damage = CGFloat(p2Button28MDown.damage) * p2Button28MDown.damageMultiplier
			p2Button28MDown.cooldown = 3
			p2MoveResult.speed! += 6
			
		case (29): //p2 Light Down
			player2Damage = CGFloat(p2Button29LDown.damage) * p2Button29LDown.damageMultiplier
			p2Button29LDown.cooldown = 2
			p2MoveResult.speed! += 9
			
		case .none:
			p2MoveResult.speed = 0
			player2Damage = 0
		default:
			break
		}
		
		
		
		
		for button in player2MoveButtons! where button.selectedButton == true { //put p2 move on cooldown
			button.cooldown = 2
		}
		p2MoveResult.damage = Int(player2Damage)
//		p2MoveResult.damage = Int(player2Damage * player1Defense)
//        print("player 2 damage = \(p2MoveResult.damage)")
	}
	
	private func getEnemyDefense() {
	//p1 move tag
		switch player1TagSelected.move {
		case 11: //if p1 moved backward
			p1MoveResult.speed! /= 2
			p1MoveResult.defenseMultiplier! *= 0.75
			
		case 13: //if p1 moved forward
			p1MoveResult.speed! *= 2
			p1MoveResult.damageMultiplier! *= 1.25
			
		
		case 10: //if p1 jumped
			p1MoveResult.speed! *= 1
			switch player2TagSelected.attack {
			case 24,25,26,.none: //p2 attacked high
				p1MoveResult.defenseMultiplier! *= 1 //if p1 jumped up and p2 attacked up, p1's defense is 1
			case 27,28,29: //p2 attacked low
				p1MoveResult.defenseMultiplier! *= 0 //if p1 jumped up and p2 attacked low, p1's defense is 0
			default:
				break
			}
		case 12: //if p1 crouched
			p1MoveResult.speed! *= 1
			switch player2TagSelected.attack {
			case 24,25,26: //p2 attacked high
				p1MoveResult.defenseMultiplier! *= 0
				
			case 27,28,29,.none: //p2 attacked low
				p1MoveResult.defenseMultiplier! *= 1
				
			default:
				break
			}
		case .none: //if p1 didnt move
			p1MoveResult.speed! *= 1
			p1MoveResult.defenseMultiplier! *= 1
		default:
			break
		}
		
	//p2 move tag
		switch player2TagSelected.move {
		case 21: //if p2 moved forward
			p2MoveResult.speed! *= 2
			p2MoveResult.damageMultiplier! *= 1.25
			
		case 23: //if p2 moved backward
			p2MoveResult.speed! /= 2.0
			p2MoveResult.defenseMultiplier! *= 0.75
		case 20: //if p2 jumped
			p2MoveResult.speed! *= 1
			switch player1TagSelected.attack {
			case 14,15,16,.none: //p1 attacked high
				p2MoveResult.defenseMultiplier! *= 1
				
			case 17,18,19: //p1 attacked low
				p2MoveResult.defenseMultiplier! *= 0
				
			default:
				break
			}
		case 22: //if p2 crouched
			p2MoveResult.speed! *= 1
			switch player1TagSelected.attack {
			case 14,15,16: //p1 attacked high
				p2MoveResult.defenseMultiplier! *= 0
				
			case 17,18,19,.none: //p1 attacked low
				p2MoveResult.defenseMultiplier! *= 1
				
			default:
				break
			}
		case .none: //if p1 didnt move
			p2MoveResult.speed! *= 1
			p2MoveResult.defenseMultiplier! *= 1
		default:
			break
		}
	}
	
	private func setupBackgroundImageView() {
		let letterArray: [String] = ["A", "B", "C"]
		guard let letter: String = letterArray.randomElement() else { return }
		backgroundName = "background\(letter)"
		
		switch letter {
		case "A":
			bgMaxCounter = 11
		case "B":
			bgMaxCounter = 8
		case "C":
			bgMaxCounter = 14
		default:
			break
		}
		
		backgroundTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.backgroundAnimation), userInfo: nil, repeats: true) //to run and change the background every 0.1 seconds
		
		ryuTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.ryuStandingAnimation), userInfo: nil, repeats: true)
		
		kenTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.kenStandingAnimation), userInfo: nil, repeats: true)
	}
	
	private func updateViewWithGame(currentGame: Game) {
		DispatchQueue.main.async {
            
//            self.turnCount = currentGame.roundNumber
            
			self.gameSessionLabel.text = currentGame.gameId
			
			self.player1ImageView.layer.cornerRadius = 25 //half of the imageView to make it round
			self.player1ImageView.layer.masksToBounds = true
            self.player1ImageView.downloaded(fromLink: "\(currentGame.player1AvatarUrl!)")
//            self.player1ImageView.image = currentGame.player1Image
			
			self.player2ImageView.layer.cornerRadius = 25 //half of the imageView to make it round
			self.player2ImageView.layer.masksToBounds = true
            self.player2ImageView.downloaded(fromLink: "\(currentGame.player2AvatarUrl!)")
//            self.player2ImageView.image = currentGame.player2Image
			
            
			self.player1NameLabel.text = "\(currentGame.player1Name!)"
			self.player1HPLabel.text = "\(currentGame.player1HP)/100"
			
			self.player2NameLabel.text = "\(currentGame.player2Name!)"
			self.player2HPLabel.text = "\(currentGame.player2HP)/100"
			
			
			if currentGame.player1Id == currentGame.player2Id { //if user is playing against itself
				self.player1MovesView.isUserInteractionEnabled = true
				self.player2MovesView.isUserInteractionEnabled = true
				self.isAgainstOnlineUser = false
			} else { //if we have a different opponent
				self.isAgainstOnlineUser = true
				if currentGame.player1Id == User.currentId() {
					self.player1MovesView.isUserInteractionEnabled = true
					self.player2MovesView.isUserInteractionEnabled = false
				} else if currentGame.player2Id == User.currentId() {
					self.player2MovesView.isUserInteractionEnabled = true
					self.player1MovesView.isUserInteractionEnabled = false
				} else {
					print("This is not our game")
				}
			}
		}
	}
	
	private func removeAttackButtonsAnimation(buttons: [MovesButton]) {
		for button in buttons where button.animation != ButtonAnimations.None {
			putAnimation(button: button, animation: ButtonAnimations.None)
		}
	}
	
//MARK: Helpers -----------------------------------------------------
	@objc func updateTurnTime() {
		clockCounter -= 1
		timeLeftLabel.text = "\(clockCounter)"
		
		if clockCounter == 0 {
			clockTimer?.invalidate()
            
			setupSelectedTag()
		}
	}
	
    private func finishTurn() {
        DispatchQueue.main.async {
            for button in self.player1AttackButtons! {
                if button.selectedButton == false { continue }
                //                        print("Selected button with animation is \(button.buttonTag)")
                switch button {
                case self.p1Button14LUp:
                    if button.animation == ButtonAnimations.SmallFire && self.p2MoveResult.defenseMultiplier! != 0 {
                        
                        self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                        if self.p1Button16HUp.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button16HUp, animation: ButtonAnimations.BigFire)
                        }
                        if self.p1Button19HDown.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button19HDown, animation: ButtonAnimations.BigFire)
                        }
                        
                    } else if self.p1Button15MUp.cooldown <= 1 && self.p1Button17LDown.cooldown <= 1 &&
                        self.p2MoveResult.defenseMultiplier! != 0 {
                        if self.p1Button15MUp.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button15MUp, animation: ButtonAnimations.SmallFire)
                        }
                        self.putAnimation(button: self.p1Button17LDown, animation: ButtonAnimations.SmallFire)
                        if self.p1Button18MDown.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button18MDown, animation: ButtonAnimations.BigFire)
                        }
                    } else {
                        self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                        continue
                    }
                case self.p1Button15MUp:
                    if button.animation == ButtonAnimations.SmallFire && self.p2MoveResult.defenseMultiplier! != 0 {
                        self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                        if self.p1Button16HUp.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button16HUp, animation: ButtonAnimations.BigFire)
                        }
                        if self.p1Button19HDown.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button19HDown, animation: ButtonAnimations.BigFire)
                        }
                    } else if self.p1Button14LUp.cooldown <= 1 && self.p1Button17LDown.cooldown <= 1 && self.p2MoveResult.defenseMultiplier! != 0 {
                        
                        self.putAnimation(button: self.p1Button14LUp, animation: ButtonAnimations.SmallFire)
                        self.putAnimation(button: self.p1Button17LDown, animation: ButtonAnimations.SmallFire)
                        if self.p1Button18MDown.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button18MDown, animation: ButtonAnimations.BigFire)
                        }
                    } else {
                        self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                        continue
                    }
                case self.p1Button16HUp:
                    self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                case self.p1Button17LDown:
                    if button.animation == ButtonAnimations.SmallFire && self.p2MoveResult.defenseMultiplier! != 0 {
                        self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                        if self.p1Button16HUp.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button16HUp, animation: ButtonAnimations.BigFire)
                        }
                        if self.p1Button19HDown.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button19HDown, animation: ButtonAnimations.BigFire)
                        }
                    } else if self.p1Button15MUp.cooldown <= 1 && self.p1Button14LUp.cooldown <= 1 && self.p2MoveResult.defenseMultiplier! != 0 {
                        if self.p1Button15MUp.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button15MUp, animation: ButtonAnimations.SmallFire)
                        }
                        self.putAnimation(button: self.p1Button14LUp, animation: ButtonAnimations.SmallFire)
                        if self.p1Button18MDown.cooldown <= 1 {
                            self.putAnimation(button: self.p1Button18MDown, animation: ButtonAnimations.BigFire)
                        }
                    } else {
                        self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                        continue
                    }
                    
                case self.p1Button18MDown:
                    self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                case self.p1Button19HDown:
                    self.removeAttackButtonsAnimation(buttons: self.player1AttackButtons!)
                default:
                    break
                }
            }
            
            for button in self.player2AttackButtons! {
                if button.selectedButton == false { continue }
                
                switch button {
                case self.p2Button26LUp:
                    if button.animation == ButtonAnimations.SmallFire && self.p1MoveResult.defenseMultiplier! != 0 {
                        self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                        
                        if self.p2Button24HUp.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button24HUp, animation: ButtonAnimations.BigFire)
                        }
                        if self.p2Button27HDown.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button27HDown, animation: ButtonAnimations.BigFire)
                        }
                    } else if self.p2Button25MUp.cooldown <= 1 && self.p2Button29LDown.cooldown <= 1 && self.p1MoveResult.defenseMultiplier! != 0 {
                        
                        if self.p2Button25MUp.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button25MUp, animation: ButtonAnimations.SmallFire)
                        }
                        self.putAnimation(button: self.p2Button29LDown, animation: ButtonAnimations.SmallFire)
                        if self.p2Button28MDown.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button28MDown, animation: ButtonAnimations.BigFire)
                        }
                    } else {
                        self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                        continue
                    }
                case self.p2Button25MUp:
                    if button.animation == ButtonAnimations.SmallFire && self.p1MoveResult.defenseMultiplier! != 0 {
                        self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                        if self.p2Button24HUp.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button24HUp, animation: ButtonAnimations.BigFire)
                        }
                        if self.p2Button27HDown.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button27HDown, animation: ButtonAnimations.BigFire)
                        }
                    } else if self.p2Button26LUp.cooldown <= 1 && self.p2Button29LDown.cooldown <= 1 && self.p1MoveResult.defenseMultiplier! != 0 {
                        self.putAnimation(button: self.p2Button26LUp, animation: ButtonAnimations.SmallFire)
                        self.putAnimation(button: self.p2Button29LDown, animation: ButtonAnimations.SmallFire)
                        if self.p2Button28MDown.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button28MDown, animation: ButtonAnimations.BigFire)
                        }
                    } else {
                        self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                        continue
                    }
                case self.p2Button24HUp:
                    self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                case self.p2Button29LDown:
                    if button.animation == ButtonAnimations.SmallFire && self.p1MoveResult.defenseMultiplier! != 0 {
                        self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                        if self.p2Button24HUp.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button24HUp, animation: ButtonAnimations.BigFire)
                        }
                        if self.p2Button27HDown.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button27HDown, animation: ButtonAnimations.BigFire)
                        }
                    } else if self.p2Button25MUp.cooldown <= 1 && self.p2Button26LUp.cooldown <= 1 && self.p1MoveResult.defenseMultiplier! != 0 {
                        if self.p2Button25MUp.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button25MUp, animation: ButtonAnimations.SmallFire)
                        }
                        self.putAnimation(button: self.p2Button26LUp, animation: ButtonAnimations.SmallFire)
                        if self.p2Button28MDown.cooldown <= 1 {
                            self.putAnimation(button: self.p2Button28MDown, animation: ButtonAnimations.BigFire)
                        }
                    } else {
                        self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                        continue
                    }
                case self.p2Button28MDown:
                    self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                case self.p2Button27HDown:
                    self.removeAttackButtonsAnimation(buttons: self.player2AttackButtons!)
                default:
                    break
                }
            }
            
            self.player1TagSelected = (nil, nil)
            self.player2TagSelected = (nil, nil)
            
            guard let allButtons = self.allButtons else { return }
            deselectOtherButtons(buttons: allButtons)
            
            if self.game!.player1Id == self.game!.player2Id { //if user is playing against itself
                self.player1MovesView.isUserInteractionEnabled = true
                self.player2MovesView.isUserInteractionEnabled = true
                self.isAgainstOnlineUser = false
            } else { //if players are 2 different opponent
                self.isAgainstOnlineUser = true
                if self.game!.player1Id == User.currentId() {
                    self.player1MovesView.isUserInteractionEnabled = true
                    self.player2MovesView.isUserInteractionEnabled = false
                } else if self.game!.player2Id == User.currentId() {
                    self.player2MovesView.isUserInteractionEnabled = true
                    self.player1MovesView.isUserInteractionEnabled = false
                } else {
                    print("This is not our game")
                }
            }
            
            for button in allButtons {
                if button.cooldown > 0 {
                    button.cooldown -= 1
                }
            }
            
            updateButtonsView(buttons: allButtons)
            
            self.turnCount += 1
            self.roundNumberLabel.text = "\(self.turnCount)"
            self.clockCounter = 8
            self.timeLeftLabel.text = "\(self.clockCounter)"
            
            self.startTurnTimer()
            
        }
    }
	
	@objc func ryuStandingAnimation() {
		self.player1Character.image = UIImage(named: "\(ryuImageName.0)\(ryuCounter)")
		ryuCounter += 1
		if ryuCounter == ryuImageName.1 {
			ryuCounter = 0
			if ryuImageName != RyuAnimationName.Standing {
				ryuImageName = RyuAnimationName.Standing
			}
		}
	}
	
	@objc func kenStandingAnimation() {
		player2Character.image = UIImage(named: "ken\(kenCounter)")
		kenCounter += 1
		if kenCounter == 13 { kenCounter = 0 }
	}
	
	@objc func backgroundAnimation() {
		backgroundImageView.image = UIImage(named: "\(backgroundName)\(backgroundCounter)")
		backgroundCounter += 1
		if backgroundCounter == bgMaxCounter { backgroundCounter = 0 }
		
	}
	
	
//MARK: IBActions -----------------------------------------------------
	@IBAction func player2MoveButtonTapped(_ sender: MovesButton) {
		deselectOtherButtons(buttons: player2MoveButtons!)
		if isAgainstOnlineUser{
			selectMoveButton(button: sender) //selectedButton = true AND add red border color
		} else { sender.selectedButton = true }
		player2TagSelected.move = sender.buttonTag
	}
	
	@IBAction func player2AttackButtonTapped(_ sender: MovesButton) {
		deselectOtherButtons(buttons: player2AttackButtons!)
		if isAgainstOnlineUser{
			selectMoveButton(button: sender) //selectedButton = true AND add red border color
		} else { sender.selectedButton = true }
		player2TagSelected.attack = sender.buttonTag
	}
	
	@IBAction func moveButtonTapped(_ sender: MovesButton) {
		deselectOtherButtons(buttons: player1MoveButtons!)
		if isAgainstOnlineUser{
			selectMoveButton(button: sender) //selectedButton = true AND add red border color
		} else { sender.selectedButton = true }
		player1TagSelected.move = sender.buttonTag
	}
	
	@IBAction func attackButtonTapped(_ sender: MovesButton) {
		deselectOtherButtons(buttons: player1AttackButtons!)
		if isAgainstOnlineUser{
			selectMoveButton(button: sender) //selectedButton = true AND add red border color
		} else { sender.selectedButton = true }
		player1TagSelected.attack = sender.buttonTag
	}
	
	
	
}
