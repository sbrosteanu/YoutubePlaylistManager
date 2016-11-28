//
//  PlaylistDetailsDataSource.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 18/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit

class PlaylistDetailsDataSource: NSObject, UITableViewDataSource {
	@available(iOS 2.0, *)
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell()
	}

	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1 // for now
	}
	
}
