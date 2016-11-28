//
//  Wireframe.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 18/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit

struct Wireframe {
	
	// MARK: - storyboards
	
	static var mainStoryboard: UIStoryboard {
		return UIStoryboard(name: "Main", bundle: nil)
	}
	
	// MARK: - viewControllers
	
	static func navigationController() -> UINavigationController {
		return mainStoryboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
	}
	
	
}
