//
//  PlaylistsCollectionViewController.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import GoogleSignIn


class PlaylistsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	@IBOutlet var dataSource: PlaylistsDataSource!
	
	
	private var collectionViewSizeChanged: Bool = false
	private var flowLayout: UICollectionViewFlowLayout!
	private let margin: CGFloat = 20.0
	
	private let youtubeService = Youtube()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		getDataAndPopulateUI()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = NSLocalizedString("My Playlists", comment: "my playlists")
		
		setupCollectionView()
		setupFlowLayout()
		dataSource.registerClasses()
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let image: UIImage = (UIImage(named: "youtubelogosmall")?.withRenderingMode(.alwaysOriginal))!
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
		
	}
	
	private func getDataAndPopulateUI() {
		
		let userDefaults = UserDefaults.standard
		
		let accessToken = userDefaults.object(forKey: "token") as! String
		if accessToken.isEmpty == false {
			youtubeService.fetcher.accessToken = accessToken
		} else {
			// authenticate LOL
		}
		youtubeService.mine = true
		
		self.collectionView?.showLoader(state: .Loading, message: NSLocalizedString("Loading...", comment: "loading"), retryAction:
			{ [weak self] in
				
				if let strongSelf = self {
					strongSelf.youtubeService.listPlaylists("snippet, contentDetails, status") { (response, error) in
						
						if let strongSelf = self {
							if error != nil {
								strongSelf.collectionView?.showLoader(state: .Error, message:  NSLocalizedString("Whoops! Something went wrong. Please retry", comment: "error text"))
								print(error)
							} else {
								if let response = response {
									if response.items.count > 0 {
										strongSelf.dataSource.playlists = response.items
										strongSelf.collectionView?.showLoader(state: .Success)
									} else {
										strongSelf.collectionView?.showLoader(state: .ErrorNoRetry, message: NSLocalizedString("You don't have any playlists added", comment: "no items in playlist"))
									}	
								}
							}
						}
					}
				}
		})
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		collectionViewSizeChanged = true
	}
 
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		
		if collectionViewSizeChanged {
			collectionView?.collectionViewLayout.invalidateLayout()
		}
	}
 
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if collectionViewSizeChanged {
			collectionViewSizeChanged = false
			collectionView?.performBatchUpdates({}, completion: nil)
		}
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let height: CGFloat = 120
		let width: CGFloat //= 162
		if traitCollection.userInterfaceIdiom == .phone {
			width = floor((collectionView.frame.size.width - 3.0 * margin) / 2.0)
		} else {
			width = floor((collectionView.frame.size.width - 5.0 * margin) / 4.0)
		}
		return CGSize(width: width, height: height)
	}
	
	
	
	private func setupCollectionView() {
		flowLayout = UICollectionViewFlowLayout()
		collectionView?.collectionViewLayout = flowLayout
		collectionView?.delegate = self
		collectionView?.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
		collectionView?.backgroundColor = StyleManager.BackgroundColor
	}
	
	private func setupFlowLayout() {
		
		flowLayout.minimumInteritemSpacing = 10
		flowLayout.minimumLineSpacing = 40
		flowLayout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let row = indexPath.row
		let model = dataSource.playlists[row]
		performSegue(withIdentifier: "PresentPlaylistDetails", sender: model)
	}
	
	
	
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PresentPlaylistDetails" {
			let playlistDetailsViewController = segue.destination as! PlaylistDetailsViewController
			let model = sender as! Playlist
			playlistDetailsViewController.model	= model
		}
	}
	
	
}
