//
//  MyView.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

@IBDesignable //allow us to use this view in designing storyboard

class MyView: UIView {
	
	@IBInspectable var cornerRadius: CGFloat = 0.0
	@IBInspectable var borderWidth: CGFloat = 0.0
	@IBInspectable var borderColor: UIColor = UIColor.clear
	
	override func draw(_ rect: CGRect) { //since we extended the UIView, we need this override the draw function
		self.layer.cornerRadius = cornerRadius
		self.layer.borderWidth = borderWidth
		self.layer.borderColor = borderColor.cgColor
	}
	
}
