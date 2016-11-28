//
//  PlaylistDetailsViewController.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 18/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import GoogleSignIn
import AlamofireImage
import ReactiveCocoa

class PlaylistDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBAction func unwindToPlaylistDetails(segue: UIStoryboardSegue) {
		if segue.identifier == "UnwindToPlaylistDetails" {
			if let addEditViewController = segue.source as? AddEditViewController, let updatedPlaylist = addEditViewController.modelForUpdate, let id = updatedPlaylist.id {
				getData(model: updatedPlaylist, playlistId: id)
			}
		}
	}
	
	
	private var flowLayout: UICollectionViewFlowLayout!
	private var collectionViewSizeChanged: Bool = false
	public var playlistId: String?
	public var model: Playlist?
	
	let margin: CGFloat = 20.0
	
	private var youtubeService: Youtube!
	
	var models: [PlaylistItem] = [] {
		didSet {
			collectionView.reloadData()
		}
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		
		youtubeService = Youtube()
		let userDefaults = UserDefaults.standard
		
		let accessToken = userDefaults.object(forKey: "token") as! String
		if accessToken.isEmpty == false {
			youtubeService.fetcher.accessToken = accessToken
		} else {
			// authenticate
		}
		youtubeService.mine = true

		collectionView.dataSource = self
		collectionView.backgroundColor = StyleManager.BackgroundColor
		
		let editButton = UIBarButtonItem(title: NSLocalizedString("Edit", comment: "edit"), style: .plain, target: self, action: #selector(didPressEdit))
		self.navigationItem.rightBarButtonItem = editButton
		
		getData(model: model, playlistId: playlistId)
	}
	
	public func getData(model: Playlist?, playlistId: String?) {
		if let model = model, let playlistId = model.id {
			youtubeService.playlistId = playlistId
			youtubeService.id = nil
			
			if let snippet = model.snippet {
				self.title = snippet.title
			}
			
			self.collectionView.showLoader(state: .Loading, message: NSLocalizedString("Loading...", comment: "loading"), retryAction: { 
				[weak self] in
				
				if let strongSelf = self {
					strongSelf.youtubeService.listPlaylistItems("snippet", completionHandler: { (response, error) in
						if error != nil {
							print(error)
							strongSelf.collectionView?.showLoader(state: .Error, message:  NSLocalizedString("Whoops! Something went wrong. Please retry", comment: "error text"))
						} else {
							if let response = response, let models = response.items {
								if models.count > 0 {
									strongSelf.getVideoDataAndPopulateUI(models: models, strongSelf: strongSelf)
								} else {
									strongSelf.collectionView?.showLoader(state: .ErrorNoRetry, message: NSLocalizedString("You don't have any items in this playlist...", comment: "no items"))
								}
							}
						}
					})
				}
			})
			
			
		}
	}
	
	public func getVideoDataAndPopulateUI(models: [PlaylistItem], strongSelf: PlaylistDetailsViewController) {
		var videoIds: String = ""

		for model in models {
			if let id = model.snippet.resourceId.videoId {
				if videoIds.isEmpty {
					videoIds.append("\(id)")
				} else {
					videoIds.append(", \(id)")
				}
			}
		}
		
		strongSelf.youtubeService.id = videoIds
		strongSelf.youtubeService.listVideos("snippet") { (response, error) in
			if error != nil {
				print(error)
				strongSelf.collectionView.showLoader(state: .Error, message: NSLocalizedString("Whoops! Something went wrong.Please retry.", comment: "error text"))
			} else {
				if let response = response, let items = response.items {
					for i in 0...items.count - 1 {
						if let snippet = items[i].snippet, let channelTitle = snippet.channelTitle {
							if let snippet = models[i].snippet {
								snippet.channelTitle = channelTitle
							}
						}
					}
					self.models = models
					strongSelf.collectionView.showLoader(state: .Success)
				}
			}
		}
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - collection view data source methods
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaylistItemCollectionViewCell", for: indexPath) as! PlaylistItemCollectionViewCell
		
		let model = models[indexPath.row]
		cell.videoTitleLabel.text = model.snippet.title
		cell.channelTitleLabel.text = model.snippet.channelTitle // will need refactoring because the channel title is on another api call.
		
		if let snippet = model.snippet, let thumbnail = snippet.thumbnails {
			
			var imageUrl = ""
			
			if let medium = thumbnail.medium, let url = medium.url {
				imageUrl = url
			} else if let standard = thumbnail.standard, let url = standard.url {
				imageUrl = url
			} else if let high = thumbnail.high, let url = high.url {
				imageUrl = url
			} else if let maxres = thumbnail.maxres, let url = maxres.url {
				imageUrl = url
			} else if let defaultRes = thumbnail.defaultValue, let url = defaultRes.url {
				imageUrl = url
			} else {
				imageUrl = "http://i.stack.imgur.com/WFy1e.jpg"
			}
			
			let url = URL(string: imageUrl)
			cell.videoImageView.af_setImage(withURL: url!, placeholderImage: UIImage(named: "novid"))
			
			
		} else {
			let imageUrl = URL(string: "http://i.stack.imgur.com/WFy1e.jpg")
			cell.videoImageView.af_setImage(withURL: imageUrl!)
		}
		cell.videoImageView.contentMode = .scaleAspectFill
		cell.videoImageView.clipsToBounds = true
		
		return cell
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return models.count
	}
	
	
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

		let height = floor(collectionView.frame.size.width / 3)
		return CGSize(width: collectionView.frame.size.width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		
		let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderReusableCollectionView
		
		if let model = self.model, let snippet = model.snippet, let thumbnail = snippet.thumbnails  {
			if let standard = thumbnail.standard, let url = standard.url {
				let imageUrl = URL(string: url)
				cell.imageView.af_setImage(withURL: imageUrl!)
			} else if let medium = thumbnail.medium, let url = medium.url {
				let imageUrl = URL(string: url)
				cell.imageView.af_setImage(withURL: imageUrl!)
			} else if let high = thumbnail.high, let url = high.url {
				let imageUrl = URL(string: url)
				cell.imageView.af_setImage(withURL: imageUrl!)
			} else if let maxres = thumbnail.maxres, let url = maxres.url {
				let imageUrl = URL(string: url)
				cell.imageView.af_setImage(withURL: imageUrl!)
			} else if let defaultRes = thumbnail.defaultValue, let url = defaultRes.url {
				let imageUrl = URL(string: url)
				cell.imageView.af_setImage(withURL: imageUrl!)
			} else {
				let imageUrl = URL(string: "http://i.stack.imgur.com/WFy1e.jpg")
				cell.imageView.af_setImage(withURL: imageUrl!)
			}
		} else {
			let imageUrl = URL(string: "http://i.stack.imgur.com/WFy1e.jpg")
			cell.imageView.af_setImage(withURL: imageUrl!)
		}
		cell.imageView.contentMode = .scaleAspectFill
		return cell
		
		
	}
	
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		collectionViewSizeChanged = true
	}
 
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		if collectionViewSizeChanged {
			collectionView.collectionViewLayout.invalidateLayout()
		}
	}
 
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			let headerHeight = floor(view.bounds.width / 3)
			let headerWidth = view.bounds.width
			
			layout.headerReferenceSize = CGSize(width: headerWidth, height: headerHeight)
			layout.invalidateLayout()
		}
		
	}
	
	@objc public func didPressEdit() {
		
		if let model = self.model {
			self.performSegue(withIdentifier: "EditPlaylist", sender: model)
		}
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "EditPlaylist" {
			let editViewController = segue.destination as! AddEditViewController
			let model = sender as! Playlist
			editViewController.modelForUpdate = model
		}
	}
	
}
