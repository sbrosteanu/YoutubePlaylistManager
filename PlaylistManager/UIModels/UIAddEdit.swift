//
//  UIAddEdit.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 20/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit

class UIAddEdit: NSObject {

	var title: String
	var text: String
	var isForNameOfPlaylist: Bool
	
	
	init(title: String, text: String, isForNameOfPlaylist: Bool) {
		self.title = title
		self.text = text
		self.isForNameOfPlaylist = isForNameOfPlaylist
	}
	
}
