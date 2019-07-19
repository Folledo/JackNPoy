//
//  AppDelegate.swift
//  HawkHackProject2019S
//
//  Created by Samuel Folledo on 3/30/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit
import Firebase
import OneSignal //for push notifications guided David Kababyan from Section 2-5

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		FirebaseApp.configure()
		
        OneSignal.initWithLaunchOptions(launchOptions, appId: kONESIGNALAPPID, handleNotificationReceived: nil, handleNotificationAction: nil, settings: nil) //for one signal //kONESIGNALAPPID is in our constant file //OneSignal S3 ep. 18
        
        Auth.auth().addStateDidChangeListener { (auth, user) in //OneSignal S3 ep. 23
            if user != nil { //OneSignal S3 ep. 23 if we have a user
                if UserDefaults.standard.object(forKey: kCURRENTUSER) != nil { //OneSignal S3 ep. 23 check that we do have a user
                    DispatchQueue.main.async { //every time our user log in, we get the user's one signal Id and save or update it if it has change //OneSignal S3 ep. 23
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, userInfo: [kUSERID: User.currentId()]) //OneSignal S3 ep. 23 8mins //this notify our user notification center, now we have to tell it what to do
                        
                    }
                }
            }
        }
        
        func onUserDidLogin(userId: String) { //OneSignal S3 ep. 23 9mins
            //start one signal //OneSignal S3 ep. 23
            startOneSignal() //OneSignal S3 ep. 23 17mins everytime our user logs in, we start one signal and receive our userId //ep.24 we update our current user's function
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "UserDidLoginNotification"), object: nil, queue: nil) { (note) in //OneSignal S3 ep. 23 10mins
            let userId = note.userInfo![kUSERID] as! String //OneSignal S3 ep. 23 11mins
            UserDefaults.standard.set(userId, forKey: kUSERID) //OneSignal S3 ep. 23 11mins
            UserDefaults.standard.synchronize() //OneSignal S3 ep. 23 12mins
            
            onUserDidLogin(userId: userId) //OneSignal S3 ep. 23 12mins
        }
        
        if #available(iOS 10.0, *) { //in case of iOS 10 //OneSignal S3 ep. 19
            let center = UNUserNotificationCenter.current() //OneSignal S3 ep. 19
            center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
            } //OneSignal S3 ep. 19
            application.registerForRemoteNotifications() //OneSignal S3 ep. 19
        } //OneSignal S3 ep. 19
        
		return true
	}
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { //OneSignal S3 ep. 19
        Auth.auth().setAPNSToken(deviceToken, type: .prod) //OneSignal S3 ep. 19 //.sandbox or .production
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) { //OneSignal S3 ep. 19
        if Auth.auth().canHandleNotification(userInfo) { //OneSignal S3 ep. 19
            completionHandler(.noData) //OneSignal S3 ep. 19
            return
        }
        
        //then this is not a firebase notification
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { //OneSignal S3 ep. 19
        print("Failed to register for user notifications") //OneSignal S3 ep. 19
    }

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
    
    
//MARK: OneSignal
    func startOneSignal() { //OneSignal S3 ep. 23 13mins
        let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState() //OneSignal S3 ep. 23 13mins
        let userID = status.subscriptionStatus.userId //OneSignal S3 ep. 23 14mins //get our userId and pushtoken
        let pushToken = status.subscriptionStatus.pushToken //OneSignal S3 ep. 23 14mins
        
        if pushToken != nil {
            if let playerId = userID { //OneSignal S3 ep. 23 15mins
                //print("\nOne Signal Id pushtoken \(pushToken)\nplayerId is \(playerId)\n")
                UserDefaults.standard.set(playerId, forKey: kONESIGNALID) //OneSignal S3 ep. 23 15mins
                UserDefaults.standard.synchronize()
            } else { //OneSignal S3 ep. 23 16mins
                UserDefaults.standard.removeObject(forKey: kONESIGNALID) //OneSignal S3 ep. 23 16mins if user doesnt have OneSignalId then remove it from UserDefaults
                UserDefaults.standard.synchronize()
            }
        }
        
    //save to user object
        updateOneSignalId() //OneSignal S3 ep. 25 6mins
    }

}

