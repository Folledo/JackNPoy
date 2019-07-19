//
//  MenuViewController.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
	
	// MARK: - Outlets
	@IBOutlet weak var chatView: MyView!
	@IBOutlet weak var loginView: UIView!
	//	@IBOutlet weak var animationView: MyView!
	
	
	//MARK: Properties
	var timer = Timer()
	
	
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
		checkCurrentUser()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		timer.invalidate() //stop timer
	}
	
	
	//MARK: Private Methods
	private func setupViews() {
		setupNav()
		
		loginView.backgroundColor = .clear
		loginView.layer.cornerRadius = 8
		loginView.clipsToBounds = true
		loginView.layer.borderWidth = 2
		
	}
	
	private func checkCurrentUser() {
		self.loginView.layer.borderColor = isUserLoggedIn() ? kGREENCGCOLOR : kREDCGCOLOR
		
		timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animateLoginView), userInfo: nil, repeats: true)
		
	}
	
	//MARK: Helpers
	@objc func animateLoginView() {
		if loginView.layer.borderWidth == 2 {
			UIView.animate(withDuration: 1) {
				self.loginView.layer.borderWidth = 0
			}
		} else {
			UIView.animate(withDuration: 1) {
				self.loginView.layer.borderWidth = 2
			}
		}
	}
	
	
	//NavigationController methods
	private func setupNav() {
		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.navigationBar.barTintColor = kCOLOR_0E5C89 //bar's backgroundColor
		navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: kHEADERTEXT, NSAttributedString.Key.foregroundColor: kCOLOR_FFFFFF] //turn title to white and font to systemFont with size and weight
		title = "Jack N' Poy"
		navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil) //removes the title when we go to child controller
	}
	override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
	
}
