//
//  ViewController.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 16/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
	
	
	@IBOutlet weak var loginButton: LoginButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().shouldFetchBasicProfile = false
		GIDSignIn.sharedInstance().scopes = [YoutubeOAuthScopes.Youtube.rawValue, YoutubeOAuthScopes.ForceSSL.rawValue]
		// button customization
		
		let userDefaults = UserDefaults.standard
		let accessToken: String? = userDefaults.object(forKey: "token") as? String
		let expirationDate: Date? = userDefaults.object(forKey: "expirationDate") as? Date
		
		if let _ = accessToken, let expirationDate = expirationDate {
			if (expirationDate.compare(Date()) == ComparisonResult.orderedDescending) || (expirationDate.compare(Date()) == ComparisonResult.orderedSame) {
				// skip login with google and access app - credentials are valid
				
				let navigationController: UINavigationController = Wireframe.navigationController() as UINavigationController
				
				let appDelegate = UIApplication.shared.delegate as! AppDelegate
				appDelegate.window?.rootViewController = navigationController
			} else {
				GIDSignIn.sharedInstance().signIn()
				// expired, will reacquire token automatically
			}
		}
		loginButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@objc private func signInWithGoogle() {
		GIDSignIn.sharedInstance().signIn()
	}
	
	
	
}

