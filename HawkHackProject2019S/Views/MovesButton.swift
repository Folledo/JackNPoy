//
//  MovesButton.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/31/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

@IBDesignable //allow us to use this view in designing storyboard

class MovesButton: UIButton {
	
//	@IBInspectable var cornerRadius: CGFloat = 0.0
//	@IBInspectable var borderWidth: CGFloat = 0.0
//	@IBInspectable var borderColor: UIColor = UIColor.clear
	
	var cooldown: Int = 0
	
	var buttonTag: Int = 0
	var selectedButton: Bool = false
	
	var multiplier: CGFloat = 1
	var damage: Int = 0
	var speed: Int = 0
	
	var animation = ButtonAnimations.None
	
	
	override func draw(_ rect: CGRect) { //since we extended the UIButton, we need this override the draw function
//		self.layer.cornerRadius = cornerRadius
//		self.layer.borderWidth = borderWidth
//		self.layer.borderColor = borderColor.cgColor
	}
	
	internal func getAttackDamage() -> CGFloat {
		return CGFloat(damage) * multiplier
	}
	
	internal func setButtonCooldown(amount: Int) { //not used yet
		self.cooldown = amount
		self.alpha = 0.5
		self.isEnabled = false
		self.setTitle("\(cooldown)", for: .normal)
	}
	
}

func selectMoveButton(button: MovesButton) {
	button.selectedButton = true
	button.layer.borderColor = UIColor.red.cgColor
	button.layer.borderWidth = 2
}

func deselectOtherButtons(buttons: [MovesButton]) {
	for button in buttons {
		button.selectedButton = false
//		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.clear.cgColor
	}
}

func updateButtonsView(buttons: [MovesButton]) {
	for button in buttons {
		if button.selectedButton == false {
			button.layer.borderColor = UIColor.clear.cgColor
		} else {
			button.layer.borderColor = UIColor.red.cgColor
		}
		
		if button.cooldown > 0 { //if on cooldown
			button.alpha = 0.5
			button.isEnabled = false
			button.setTitle("\(button.cooldown)", for: .normal)
		} else { //enable
			button.alpha = 1
			button.isEnabled = true
			button.setTitle("", for: .normal)
		}
	}
}


