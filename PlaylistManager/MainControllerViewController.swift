//
//  MainControllerViewController.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import GoogleSignIn

class MainControllerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let youtubeService = Youtube()
		let accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
		
		if accessToken != nil {
			youtubeService.fetcher.accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
		}
		
		youtubeService.mine = true
		
		youtubeService.listPlaylists("snippet") { (response, error) in
			if error != nil {
				print(error)
			} else {
				if let response = response {
					print(response)
				}
			}
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
