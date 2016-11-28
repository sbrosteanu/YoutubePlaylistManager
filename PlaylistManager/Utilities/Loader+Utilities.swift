//
//  Loader+Utilities.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 25/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit

enum LoaderState {
	case Loading
	case Success
	case Error
	case ErrorNoRetry
}

protocol Loading {
	var state: LoaderState {get}
	var message: String {get set}
	var retryButtonAction: (() -> Void)? {get set}
	
	func setState(state: LoaderState)
}

class UILoader: UIView, Loading {
	//Private UI properties
	private let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
	private let messageLabel: UILabel = UILabel()
	private let retryButton: UIButton = UIButton(type: .system)
	
	//Public properties
	var state: LoaderState = .Loading
	
	var message: String {
		set {
			messageLabel.text = newValue
		}
		get {
			return messageLabel.text ?? ""
		}
	}
	
	var retryButtonAction: (() -> Void)?
	
	override var tintColor: UIColor! {
		didSet {
			activityIndicator.color = tintColor
		}
	}
	
	//Public methods
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	func setState(state: LoaderState) {
		self.state = state
		switch state {
		case .Loading:
			retryButtonAction?()
			UIView.animate(withDuration: 0.35, animations: {
				self.activityIndicator.startAnimating()
				self.messageLabel.alpha = 0.0
				self.retryButton.alpha = 0.0
				self.alpha = 1.0
			})
		case .Error:
			UIView.animate(withDuration: 0.35, animations: {
				self.alpha = 1.0
				self.activityIndicator.stopAnimating()
				self.messageLabel.alpha = 1.0
				self.retryButton.alpha = 1.0
			})
		case .Success:
			UIView.animate(withDuration: 0.35, animations: {
				self.activityIndicator.stopAnimating()
				self.alpha = 0.0
				self.messageLabel.alpha = 0.0
				self.retryButton.alpha = 0.0
			})
		case .ErrorNoRetry:
			UIView.animate(withDuration: 0.35, animations: {
				self.alpha = 1.0
				self.activityIndicator.stopAnimating()
				self.messageLabel.alpha = 1.0
				self.retryButton.alpha = 0.0
			})
		}
	}
	
	func executeButtonAction() {
		setState(state: .Loading)
	}
	
	//Private methods
	private final func commonInit() {
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		retryButton.translatesAutoresizingMaskIntoConstraints = false
		
		activityIndicator.color = StyleManager.OverlayColor
		
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		messageLabel.textColor = StyleManager.SecondaryTextColor
		messageLabel.font = UIFont.boldSystemFont(ofSize: 24)
		
		retryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		retryButton.setTitleColor(StyleManager.OverlayColor, for: .normal)
		retryButton.setTitle(NSLocalizedString("RETRY", comment: "RETRY button"), for: .normal)
		retryButton.addTarget(self, action: #selector(UILoader.executeButtonAction), for: .touchUpInside)
		
		messageLabel.alpha = 0.0
		retryButton.alpha = 0.0
		
		addSubview(activityIndicator)
		addSubview(messageLabel)
		addSubview(retryButton)
		
		setupLayout()
	}
	
	private final func setupLayout() {
		var constraintsArray = [NSLayoutConstraint]()
		
		let viewsDictionary = ["activityIndicator":activityIndicator,
		                       "messageLabel":messageLabel,
		                       "retryButton":retryButton]
		
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[messageLabel]-|", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[messageLabel(100@750)]-40-[retryButton(20)]", options: [], metrics: nil, views: viewsDictionary))
		constraintsArray.append(NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
		constraintsArray.append(NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
		
		constraintsArray.append(NSLayoutConstraint(item: messageLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
		constraintsArray.append(NSLayoutConstraint(item: messageLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
		
		constraintsArray.append(NSLayoutConstraint(item: retryButton, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
		
		
		self.addConstraints(constraintsArray)
	}
}

extension UITableView {
	func showLoader(state: LoaderState, message: String = "", retryAction: (() -> Void)? = nil) {
		if var loaderView = backgroundView as? Loading {
			loaderView.message = message
			if retryAction != nil {
				loaderView.retryButtonAction = retryAction
			}
			loaderView.setState(state: state)
		} else {
			let loaderView = UILoader(frame: bounds)
			loaderView.message = message
			if retryAction != nil {
				loaderView.retryButtonAction = retryAction
			}
			
			backgroundView = loaderView
			
			loaderView.setState(state: state)
		}
	}
}

extension UICollectionView {
	func showLoader(state: LoaderState, message: String = "", retryAction: (() -> Void)? = nil) {
		if var loaderView = backgroundView as? Loading {
			loaderView.message = message
			if retryAction != nil {
				loaderView.retryButtonAction = retryAction
			}
			loaderView.setState(state: state)
		} else {
			let loaderView = UILoader(frame: bounds)
			loaderView.message = message
			if retryAction != nil {
				loaderView.retryButtonAction = retryAction
			}
			
			backgroundView?.backgroundColor = self.backgroundColor
			backgroundView = loaderView
			
			loaderView.setState(state: state)
		}
	}
}
