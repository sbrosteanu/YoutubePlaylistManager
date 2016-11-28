//
//  AddEditViewController.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 19/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import GoogleSignIn

class AddEditViewController: UIViewController {
	
	@IBOutlet var dataSource: AddEditDataSource!
	@IBOutlet weak var tableView: UITableView!
	
	var modelForUpdate: Playlist? {
		didSet {
			isForUpdate = true
		}
	}
	
	
	private var isForUpdate = false
	private var initialTitle: String = ""
	private var initialPrivacy: String = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// setup navigation bar
		
		let saveButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: "save"), style: .done, target: self, action: #selector(saveTapped))
		self.navigationItem.rightBarButtonItem = saveButton
		
		tableView.dataSource = dataSource
		tableView.backgroundColor = StyleManager.BackgroundColor
		dataSource.registerClasses()
		tableView.tableFooterView = UIView()
		tableView.tableFooterView?.backgroundColor = StyleManager.BackgroundColor
		tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
		
		if modelForUpdate != nil {
			dataSource.models = generateUIModels(model: modelForUpdate)
			self.title = NSLocalizedString("Edit playlist", comment: "edit playlist")
		} else {
			dataSource.models = generateUIModels(model: nil)
			self.title = NSLocalizedString("Add new playlist", comment: "add new playlist")
		}
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	@objc func saveTapped() {
		// here we'll save or update the API
		// create new model for both cases, as the api doesn't need to get all the initial data in case of update.
		
		let youtubeService = Youtube()
		
		let userDefaults = UserDefaults.standard
		let accessToken = userDefaults.object(forKey: "token") as! String
		
		if accessToken.isEmpty == false {
			youtubeService.fetcher.accessToken = accessToken
		} else {
			// authenticate LOL
		}
		
		
		if let models = dataSource.models {
			
			var newTitle: String = ""
			var newPrivacyStatus: String = ""
			
			for model in models {
				if model.isForNameOfPlaylist == true {
					newTitle = model.text
				} else {
					newPrivacyStatus = model.text
				}
			}
			
			if (newTitle != initialTitle) || (newPrivacyStatus != initialPrivacy) {
				
				let newPlaylist = Playlist()
				let newPlaylistSnippet = PlaylistSnippet()
				let newPlaylistStatus = ItemStatus()
				
				newPlaylistSnippet.title = newTitle
				newPlaylistStatus.privacyStatus = PrivacyStatus(rawValue: newPrivacyStatus)
				
				newPlaylist.snippet = newPlaylistSnippet
				newPlaylist.status = newPlaylistStatus
				
				
				if self.isForUpdate == true, let toBeUpdated = modelForUpdate {
					newPlaylist.id = toBeUpdated.id
					youtubeService.updatePlaylists(newPlaylist, part: "snippet, status", completionHandler: { [weak self] (updatedPlaylist, error) in
						if let strongSelf = self {
							if error != nil {
								print(error)
							} else {
								
								if let updatedPlaylist = updatedPlaylist {
									strongSelf.modelForUpdate = updatedPlaylist
									strongSelf.performSegue(withIdentifier: "UnwindToPlaylistDetails", sender: strongSelf)
								}
							}
						}
					})
				} else {
					youtubeService.insertPlaylists(newPlaylist, part: "snippet, status", completionHandler: { [weak self] (playlist, error) in
						if let strongSelf = self {
							if error != nil {
								print(error)
							} else {
								print("****saved new playlist*****")
								let navigationController = strongSelf.navigationController
								if let navigationController = navigationController {
									navigationController.popViewController(animated: true)
								}
							}
						}
					})
				}
			} else {
				
				print("****** NoTHING TO UPDATE ********")
				// show alert view.
				
				let alert = UIAlertController(title: NSLocalizedString("Warning!", comment: "warning"), message: NSLocalizedString("You don't have anything to update!", comment: "nothing to update"), preferredStyle: .alert)
				let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				alert.addAction(okAction)
				self.present(alert, animated: true, completion: nil)
			}
			
			
		}
		
		
		
	
	}
	
	
	func generateUIModels(model: Playlist?) -> [UIAddEdit] {
		var models: [UIAddEdit] = [UIAddEdit]()
		
		if let model = model {
			let playlistName = UIAddEdit(title: NSLocalizedString("Playlist name", comment: "playlist name"), text: model.snippet.title, isForNameOfPlaylist: true)
			let playlistStatus = UIAddEdit(title: NSLocalizedString("Locked", comment: "locked"), text: model.status.privacyStatus.rawValue, isForNameOfPlaylist: false)
			
			initialTitle = playlistName.text
			initialPrivacy = playlistStatus.text
			
			models.append(playlistName)
			models.append(playlistStatus)
			
		} else {
			let playlistName = UIAddEdit(title: NSLocalizedString("Playlist name", comment: "playlist name"), text: "", isForNameOfPlaylist: true)
			let playlistStatus = UIAddEdit(title: NSLocalizedString("Locked", comment: "locked"), text: "", isForNameOfPlaylist: false)
			
			initialTitle = playlistName.text
			initialPrivacy = playlistStatus.text
			
			
			models.append(playlistName)
			models.append(playlistStatus)
		}
		return models
		
	}
	
}
