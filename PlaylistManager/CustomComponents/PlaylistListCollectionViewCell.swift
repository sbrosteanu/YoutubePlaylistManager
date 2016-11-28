//
//  PlaylistListCollectionViewCell.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import AlamofireImage

class PlaylistListCollectionViewCell: UICollectionViewCell {
	
	var model: Playlist? {
		didSet {
			if let model = model {
				if let contentDetails = model.contentDetails {
					if let vidNumber = contentDetails.itemCount {
						if vidNumber == 1 {
							overlayView.alpha = 1.0
							numberOfVideosLabel.text = "\(vidNumber) \n video"
						} else {
							if vidNumber == 0 {
								overlayView.alpha = 0.0
							} else {
								overlayView.alpha = 1.0
								numberOfVideosLabel.text = "\(vidNumber) \n videos"
							}
						}
					}
				}
				
				if let snippet = model.snippet {
					if let title = snippet.title {
						playlistTitleLabel.text = title
					}
					if let thumbnails = snippet.thumbnails {
						if let medium = thumbnails.medium, let url = medium.url {
							let imageUrl = URL(string: url)
							playlistImageView.af_setImage(withURL: imageUrl!)
						} else if let standard = thumbnails.standard, let url = standard.url {
							let imageUrl = URL(string: url)
							playlistImageView.af_setImage(withURL: imageUrl!)
						} else if let high = thumbnails.high, let url = high.url {
							let imageUrl = URL(string: url)
							playlistImageView.af_setImage(withURL: imageUrl!)
						} else if let maxres = thumbnails.maxres, let url = maxres.url {
							let imageUrl = URL(string: url)
							playlistImageView.af_setImage(withURL: imageUrl!)
						} else if let defaultRes = thumbnails.defaultValue, let url = defaultRes.url {
							let imageUrl = URL(string: url)
							playlistImageView.af_setImage(withURL: imageUrl!)
						} else {
							let imageUrl = URL(string: "http://i.stack.imgur.com/WFy1e.jpg")
							playlistImageView.af_setImage(withURL: imageUrl!)
						}
					} else {
						let imageUrl = URL(string: "http://i.stack.imgur.com/WFy1e.jpg")
						playlistImageView.af_setImage(withURL: imageUrl!)
					}
					
				}
				
				if let privacyStatus = model.status {
					switch privacyStatus.privacyStatus.rawValue {
					case "private": fallthrough
					case "unlisted" :
						statusLabel.alpha = 1.0
						statusLabel.text = "locked"
						break
					case "public":
						fallthrough
					default:
						statusLabel.alpha = 0.0
						break
					}
					
					
				}
			}
		}
	}
	

	private let playlistImageView: UIImageView = UIImageView()
	private let overlayView: UIView = UIView()
	private let numberOfVideosLabel: UILabel = UILabel()
	private let playlistTitleLabel: UILabel = UILabel()
	private let statusLabel: UILabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		playlistImageView.af_cancelImageRequest()
		playlistImageView.image = nil
	}
	
	private func commonInit() {
		playlistImageView.translatesAutoresizingMaskIntoConstraints = false
		overlayView.translatesAutoresizingMaskIntoConstraints = false
		numberOfVideosLabel.translatesAutoresizingMaskIntoConstraints = false
		playlistTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		statusLabel.translatesAutoresizingMaskIntoConstraints = false
		
		playlistImageView.contentMode = .scaleAspectFill
		playlistImageView.clipsToBounds = true
		
		playlistTitleLabel.font = UIFont.boldSystemFont(ofSize: 12)
		playlistTitleLabel.adjustsFontSizeToFitWidth = true
		playlistTitleLabel.textAlignment = .right
		
		
		statusLabel.font = UIFont.boldSystemFont(ofSize: 10)
		statusLabel.adjustsFontSizeToFitWidth = true
		statusLabel.textAlignment = .center
		statusLabel.textColor = StyleManager.White
		statusLabel.backgroundColor = StyleManager.BackgroundGray
		
		numberOfVideosLabel.textColor = UIColor.white
		numberOfVideosLabel.font = UIFont.boldSystemFont(ofSize: 10)
		numberOfVideosLabel.numberOfLines = 2
		numberOfVideosLabel.textAlignment = .center
		overlayView.addSubview(numberOfVideosLabel)
		
		overlayView.backgroundColor = StyleManager.OverlayColor
		playlistImageView.addSubview(overlayView)
		
		
		contentView.addSubview(playlistImageView)
		contentView.addSubview(statusLabel)
		contentView.addSubview(playlistTitleLabel)
		
		setupLayout()
	}
	
	private func setupLayout() {
		
		let viewsDictionary = ["imageView": playlistImageView,
		                       "title": playlistTitleLabel,
		                       "overlay": overlayView,
		                       "noOfVidsLabel": numberOfVideosLabel,
		                       "status": statusLabel]
		
		var constraintsArray = [NSLayoutConstraint]()
		
		
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView(100)]-[title]|", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[status(40)]-[title]|", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[imageView]-[status]|", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[overlay]|", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:[overlay(50)]|", options: [], metrics: nil, views: viewsDictionary))
		
		constraintsArray.append(NSLayoutConstraint(item: numberOfVideosLabel, attribute: .centerY, relatedBy: .equal, toItem: overlayView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
		constraintsArray.append(NSLayoutConstraint(item: numberOfVideosLabel, attribute: .centerX, relatedBy: .equal, toItem: overlayView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
		
		contentView.addConstraints(constraintsArray)

	}

}
