//
//  LoginButton.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 16/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit

@IBDesignable class LoginButton: UIControl {

	private var containerView: UIView = UIView()
	private var textLabel: UILabel = UILabel()
	private let imageView = UIImageView(image: UIImage(named: "google.png"))
	
	
	@IBInspectable var title: String {
		set {
			textLabel.text = newValue
		}
		get {
			return textLabel.text ?? ""
		}
	}
	
	override init (frame: CGRect) {
		super.init(frame: frame)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}
	
	
	private func commonInit() {
		containerView.translatesAutoresizingMaskIntoConstraints = false
		textLabel.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		
		imageView.contentMode = .scaleAspectFit
		containerView.backgroundColor = StyleManager.ButtonRed
		textLabel.font = UIFont.boldSystemFont(ofSize: 15)
		textLabel.textColor = StyleManager.White
		textLabel.text = NSLocalizedString("Login with Google", comment: "login with google")
		imageView.image = UIImage(named: "googleplus")
		
		containerView.isUserInteractionEnabled = false
		
		containerView.addSubview(textLabel)
		containerView.addSubview(imageView)
		self.addSubview(containerView)
		
		self.layer.cornerRadius = 6
		self.clipsToBounds = true
		
		setupLayout()
	}
	
	private func setupLayout() {
		let viewsDictionary = ["container": containerView,
		                       "text": textLabel,
		                       "imageView": imageView]
		var constraintsArray = [NSLayoutConstraint]()
		
		constraintsArray.append(NSLayoutConstraint(item: textLabel, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
		constraintsArray.append(NSLayoutConstraint(item: textLabel, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
		
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[imageView(20)]", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView(20)]", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
		
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|[container]|", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|[container]|", options: [], metrics: nil, views: viewsDictionary))
		
		self.addConstraints(constraintsArray)
	}
	
	
	
}
