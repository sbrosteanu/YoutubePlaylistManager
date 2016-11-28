//
//  PlaylistsDataSource.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit

class PlaylistsDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
	@IBOutlet weak var collectionView: UICollectionView!
	
	static fileprivate let PlaylistsItemCell = String(describing: PlaylistListCollectionViewCell.self)
	
	var playlists: [Playlist] = [] {
		didSet {
			collectionView.reloadData()
		}
	}
	
	
	func registerClasses() {
		collectionView?.register(PlaylistListCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistsDataSource.PlaylistsItemCell)
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return playlists.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let model = playlists[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistsDataSource.PlaylistsItemCell, for: indexPath) as! PlaylistListCollectionViewCell
		cell.model = model
		return cell
	}
		
}
