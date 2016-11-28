//
//  AddEditDataSource.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 20/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit

class AddEditDataSource: NSObject, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	
	static let cellIdentifier = String(describing: AddEditTableViewCell.self)
	
	public var models: [UIAddEdit]? {
		didSet {
			tableView.reloadData()
		}
	}
	
	public func registerClasses() {
		tableView.register(AddEditTableViewCell.self, forCellReuseIdentifier: AddEditDataSource.cellIdentifier)
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: AddEditDataSource.cellIdentifier) as! AddEditTableViewCell
		cell.model = models?[indexPath.row]
		return cell
	}
	
}
