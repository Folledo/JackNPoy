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
	
	@IBOutlet weak var p1Button24ImageView: UIImageView!
	@IBOutlet weak var p1Button25ImageView: UIImageView!
	@IBOutlet weak var p1Button26ImageView: UIImageView!
	@IBOutlet weak var p1Button27ImageView: UIImageView!
	@IBOutlet weak var p1Button28ImageView: UIImageView!
	@IBOutlet weak var p1Button29ImageView: UIImageView!
	
	
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
		
		p1Button14LUp.animation = ButtonAnimations.SmallFire
		p1Button15MUp.animation = ButtonAnimations.SmallFire
		p1Button17LDown.animation = ButtonAnimations.BigFire
		p1Button18MDown.animation = ButtonAnimations.BigFire
		
		putAnimation(button: p1Button14LUp)
		putAnimation(button: p1Button15MUp)
		putAnimation(button: p1Button17LDown)
		putAnimation(button: p1Button18MDown)
		
//		bigFireTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.playButtonAnimation), userInfo: nil, repeats: true)
//		smallFireTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.playButtonAnimation), userInfo: nil, repeats: true)
		
		updateViewWithGame(currentGame: game!)
		
		startTurnTimer()
    }
    
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		backgroundTimer?.invalidate()
		clockTimer?.invalidate()
		ryuTimer?.invalidate()
		kenTimer?.invalidate()
	}
	
	private func putAnimation(button: MovesButton) {
		var images: [UIImage] = []
		if button.animation == ButtonAnimations.None {
			print("None11")
			return
		} else if button.animation == ButtonAnimations.SmallFire {
			for i in 0 ... ButtonAnimations.SmallFire.1 {
				images.append(UIImage(named: "\(ButtonAnimations.SmallFire.0)\(i)")!)
			}
		} else if button.animation == ButtonAnimations.BigFire {
			for i in 0 ... ButtonAnimations.BigFire.1 {
				images.append(UIImage(named: "\(ButtonAnimations.BigFire.0)\(i)")!)
			}
		} else { print("weird button animations") }
		
		button.setBackgroundImage(UIImage.animatedImage(with: images, duration: 1), for: .normal)
		
//		button.imageView?.animationImages = images
//		button.imageView?.animationDuration = 1
//		button.imageView?.startAnimating()
		
	}
	
	
//MARK: Private methods -----------------------------------------------------
	private func setupPlayersButtons() {
		player1MoveButtons = [p1Button10Up, p1Button11Back, p1Button12Down, p1Button13Forward]
		player1AttackButtons = [p1Button14LUp, p1Button15MUp, p1Button16HUp, p1Button17LDown, p1Button18MDown, p1Button19HDown]
		
		player2MoveButtons = [p2Button20Up, p2Button21Forward, p2Button22Down, p2Button23Back]
		player2AttackButtons = [p2Button24HUp, p2Button25MUp, p2Button26LUp, p2Button27HDown, p2Button28MDown, p2Button29LDown]
		
		allButtons = (player1MoveButtons! + player1AttackButtons! + player2MoveButtons! + player2AttackButtons!)
		
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
		clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTurnTime), userInfo: nil, repeats: true)
	}
	
	
	private func changeCharactersAnimationNames(completion: @escaping () -> Void) { //or () -> ()
//		print("p1: \(player1TagSelected)")
//		print("p2: \(player2TagSelected)")
		
		p1MoveResult = (damage:0, damageMultiplier:1, defenseMultiplier:1, speed:0)
		p2MoveResult = (damage:0, damageMultiplier:1, defenseMultiplier:1, speed:0)
		
//		p1Button14LUp.animation = ButtonAnimations.None
//
		player1MovesView.isUserInteractionEnabled = false
		player2MovesView.isUserInteractionEnabled = false
		
		getPlayer1Damage()
		getPlayer2Damage()
		getEnemyDefense()
		
		
		ryuCounter = 0
		
		let player1Damage = Int(CGFloat(p1MoveResult.damage!) * p1MoveResult.damageMultiplier! * p2MoveResult.defenseMultiplier!)
		let player2Damage = Int(CGFloat(p2MoveResult.damage!) * p2MoveResult.damageMultiplier! * p1MoveResult.defenseMultiplier!)
//		print("P1 Damage is \(player2Damage)\nP2 damage is \(player1Damage)")
		
		print("P1 \(p1MoveResult)\nP2 \(p2MoveResult)")
		
		
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
			print("p1 first")
			self.player2Hp -= player1Damage
			self.player2HPProgress.completedUnitCount += Int64(player1Damage)
			let player2ProgressFloat = Float(self.player2HPProgress.fractionCompleted)
			self.player2HPBar.setProgress(player2ProgressFloat, animated: true)
			
			
			if player2Hp > 0 { //if p2 is still alive
				self.player1Hp -= player2Damage
				self.player1HPProgress.completedUnitCount += Int64(player2Damage)
				let player1ProgressFloat = Float(self.player1HPProgress.fractionCompleted)
				self.player1HPBar.setProgress(player1ProgressFloat, animated: true)
				self.player1HPLabel.text = "\(player1Hp)/100"
				self.player2HPLabel.text = "\(player2Hp)/100"
			} else { //if p2 dies
				self.player1HPLabel.text = "WIN!"
				self.player2HPLabel.text = "LOSE"
				return
			}
			
		} else { //if p2 first
			print("p2 first")
			self.player1Hp -= player2Damage
			self.player1HPProgress.completedUnitCount += Int64(player2Damage)
			let player1ProgressFloat = Float(self.player1HPProgress.fractionCompleted)
			self.player1HPBar.setProgress(player1ProgressFloat, animated: true)
			
			if player1Hp > 0 { //if p1 is still alive
				self.player2Hp -= player1Damage
				self.player2HPProgress.completedUnitCount += Int64(player1Damage)
				let player2ProgressFloat = Float(self.player2HPProgress.fractionCompleted)
				self.player2HPBar.setProgress(player2ProgressFloat, animated: true)
				self.player1HPLabel.text = "\(player1Hp)/100"
				self.player2HPLabel.text = "\(player2Hp)/100"
			} else { //if p1 dies
				self.player1HPLabel.text = "LOSE"
				self.player2HPLabel.text = "WIN!"
				return
			}
			
		}
		
		
		
		
//		self.player1HPProgress.completedUnitCount += Int64(player2Damage)
//		self.player2HPProgress.completedUnitCount += Int64(player1Damage)
//
//		let player1ProgressFloat = Float(self.player1HPProgress.fractionCompleted)
//		let player2ProgressFloat = Float(self.player2HPProgress.fractionCompleted)
//
//		self.player1HPBar.setProgress(player1ProgressFloat, animated: true)
//		self.player2HPBar.setProgress(player2ProgressFloat, animated: true)
//
//
//
//		if player1Hp <= 0 {
//			self.player1HPLabel.text = "LOSE"
//			self.player2HPLabel.text = "WIN!"
//			return
//		} else if player2Hp <= 0 {
//			self.player1HPLabel.text = "WIN!"
//			self.player2HPLabel.text = "LOSE"
//			return
//		} else {
//			self.player1HPLabel.text = "\(player1Hp)/100"
//			self.player2HPLabel.text = "\(player2Hp)/100"
//		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: { //delay
			
			self.player1DamageLabel.isHidden = true
			self.player2DamageLabel.isHidden = true

			
			completion()
		})
		
	}
	
	
	private func getPlayer1Damage() {
		var player1Damage: CGFloat = 0
//		var player2Defense: CGFloat = 1
		
		
		switch player1TagSelected.attack {
		case (14): //p1 Light Up
			ryuImageName = RyuAnimationName.Jump
			player1Damage = CGFloat(p1Button14LUp.damage) * p1Button14LUp.multiplier
			
			
			
			p1Button14LUp.cooldown = 2
			p1MoveResult.speed! = 3
			
		case (15): //p1 Medium Up
			player1Damage = CGFloat(p1Button15MUp.damage) * p1Button15MUp.multiplier
			p1Button15MUp.cooldown = 3
			
			p1MoveResult.speed! = 6
			
		case (16): //p1 Heavy Up
			player1Damage = CGFloat(p1Button16HUp.damage) * p1Button16HUp.multiplier
			p1Button16HUp.cooldown = 4
			
			p1MoveResult.speed! = 9
			
		case (17): //p1 Light Down
			player1Damage = CGFloat(p1Button17LDown.damage) * p1Button17LDown.multiplier
			
			p1Button17LDown.cooldown = 2
			p1MoveResult.speed! = 3
			
			
		case (18): //p1 Medium Down
			player1Damage = CGFloat(p1Button18MDown.damage) * p1Button18MDown.multiplier
			
			p1Button18MDown.cooldown = 3
			p1MoveResult.speed! = 6
			
				
		case (19): //p1 Heavy Down
			player1Damage = CGFloat(p1Button19HDown.damage) * p1Button19HDown.multiplier
			
			p1Button19HDown.cooldown = 4
			p1MoveResult.speed! = 9
			
			
		case .none:
			player1Damage = 0
		default:
			break
		}
		
		
		
		for button in player1MoveButtons! where button.selectedButton == true { //put p1 move on cooldown
			button.cooldown = 2
		}
		
		p1MoveResult.damage = Int(player1Damage)
	}
	

	private func getPlayer2Damage() {
		var player2Damage: CGFloat = 0
		
		switch player2TagSelected.attack {
		case (24): //p2 Heavy Up
			player2Damage = CGFloat(p2Button24HUp.damage) * p2Button24HUp.multiplier
			p2MoveResult.speed = 3
			p2Button24HUp.cooldown = 4
			
			
		case (25): //p2 Medium Up
			player2Damage = CGFloat(p2Button25MUp.damage) * p2Button25MUp.multiplier
			p2Button25MUp.cooldown = 3
			p2MoveResult.speed = 6
			
			
		case (26): //p2 Light Up
			player2Damage = CGFloat(p2Button26LUp.damage) * p2Button26LUp.multiplier
			p2Button26LUp.cooldown = 2
			
			p2MoveResult.speed = 9
			
		case (27): //p2 Heavy Down
			player2Damage = CGFloat(p2Button27HDown.damage) * p2Button27HDown.multiplier
			p2Button27HDown.cooldown = 4
			
			p2MoveResult.speed = 3
			
		case (28): //p2 Medium Down
			player2Damage = CGFloat(p2Button28MDown.damage) * p2Button28MDown.multiplier
			p2Button28MDown.cooldown = 3
			
			p2MoveResult.speed = 6
			
		case (29): //p2 Light Down
			player2Damage = CGFloat(p2Button29LDown.damage) * p2Button29LDown.multiplier
			p2Button29LDown.cooldown = 2
			
			p2MoveResult.speed = 9
			
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
				p2MoveResult.defenseMultiplier! *= 1
			case 27,28,29: //p2 attacked low
				p2MoveResult.defenseMultiplier! *= 0
			default:
				break
			}
		case 12: //if p1 crouched
			p1MoveResult.speed! *= 1
			switch player2TagSelected.attack {
			case 24,25,26: //p2 attacked high
				p2MoveResult.defenseMultiplier! *= 0
				
			case 27,28,29,.none: //p2 attacked low
				p2MoveResult.defenseMultiplier! *= 1
				
			default:
				break
			}
		case .none: //if p1 didnt move
			p1MoveResult.speed! *= 1
			p2MoveResult.defenseMultiplier! *= 1
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
				p1MoveResult.defenseMultiplier! *= 1
				
			case 17,18,19: //p1 attacked low
				p1MoveResult.defenseMultiplier! *= 0
				
			default:
				break
			}
		case 22: //if p2 crouched
			p2MoveResult.speed! *= 1
			switch player1TagSelected.attack {
			case 14,15,16: //p1 attacked high
				p1MoveResult.defenseMultiplier! *= 0
				
			case 17,18,19,.none: //p1 attacked low
				p1MoveResult.defenseMultiplier! *= 1
				
			default:
				break
			}
		case .none: //if p1 didnt move
			p2MoveResult.speed! *= 1
			p1MoveResult.defenseMultiplier! *= 1
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
			self.gameSessionLabel.text = currentGame.gameId
			
			self.player1ImageView.layer.cornerRadius = 25 //half of the imageView to make it round
			self.player1ImageView.layer.masksToBounds = true
			self.player1ImageView.downloaded(fromLink: "\(currentGame.player1AvatarUrl!)")
			
			self.player2ImageView.layer.cornerRadius = 25 //half of the imageView to make it round
			self.player2ImageView.layer.masksToBounds = true
			self.player2ImageView.downloaded(fromLink: "\(currentGame.player2AvatarUrl!)")
			
			
			self.player1NameLabel.text = "\(currentGame.player1Name!)"
			self.player1HPLabel.text = "\(currentGame.player1HP)/100"
			
			self.player2NameLabel.text = "\(currentGame.player2Name!)"
			self.player2HPLabel.text = "\(currentGame.player2HP)/100"
			
		}
		
		
		
		//		updatePlayer1Views()
		//		updatePlayer2Views()
		
		
	}
	
	
//MARK: Helpers -----------------------------------------------------
	@objc func updateTurnTime() {
		clockCounter -= 1
		timeLeftLabel.text = "\(clockCounter)"
		
		if clockCounter == 0 {
			clockTimer?.invalidate()
			
			changeCharactersAnimationNames {
				self.player1TagSelected = (nil, nil)
				self.player2TagSelected = (nil, nil)
				
				guard let allButtons = self.allButtons else { return }
				
				deselectOtherButtons(buttons: allButtons)
				
				self.player1MovesView.isUserInteractionEnabled = true
				self.player2MovesView.isUserInteractionEnabled = true
				
				for button in allButtons {
					if button.cooldown > 0 {
						button.cooldown -= 1
					}
				}
				
				updateButtonsView(buttons: allButtons)
				
				self.clockCounter = 8
				self.timeLeftLabel.text = "\(self.clockCounter)"
				self.startTurnTimer()
				
			}
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
		selectMoveButton(button: sender) //selectedButton = true AND add red border color
		
		player2TagSelected.move = sender.buttonTag
		
	}
	
	@IBAction func player2AttackButtonTapped(_ sender: MovesButton) {
		deselectOtherButtons(buttons: player2AttackButtons!)
		selectMoveButton(button: sender) //selectedButton = true AND add red border color
		
		player2TagSelected.attack = sender.buttonTag
	}
	
	@IBAction func moveButtonTapped(_ sender: MovesButton) {
		deselectOtherButtons(buttons: player1MoveButtons!)
		selectMoveButton(button: sender) //selectedButton = true AND add red border color
		
		player1TagSelected.move = sender.buttonTag
	}
	
	@IBAction func attackButtonTapped(_ sender: MovesButton) {
		
		deselectOtherButtons(buttons: player1AttackButtons!)
		selectMoveButton(button: sender) //selectedButton = true AND add red border color
		
		player1TagSelected.attack = sender.buttonTag
	}
	
	
	
}
