//
//  AddEditTableViewCell.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 19/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import ReactiveCocoa

public class AddEditTableViewCell: UITableViewCell {
	
	private let titleLabel: UILabel = UILabel()
	private let textField: UITextField = UITextField()
	private let statusSwitch: UISwitch = UISwitch()
	private var isNameField: Bool = false
	
	var model: UIAddEdit? {
		didSet {
			if let model = model {
				titleLabel.text = model.title
				
				if model.isForNameOfPlaylist {
					isNameField = true
					
					if model.text.isEmpty == false {
						textField.text = model.text
					} else {
						textField.text = ""
					}
				} else {
					isNameField = false
					
					if (model.text.isEmpty) || (model.text == "public") {
						statusSwitch.isOn = false
					} else {
						statusSwitch.isOn = true
					}
				}
				commonInit()
				setNeedsLayout()
			}
		}
	}
	
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		commonInit()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}
	
	private func commonInit() {
		textField.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		statusSwitch.translatesAutoresizingMaskIntoConstraints = false
		
		textField.textColor = StyleManager.SecondaryTextColor
		textField.textAlignment = .right
		
		if isNameField == true {
			statusSwitch.alpha = 0.0
			statusSwitch.isEnabled = false
			textField.alpha = 1.0
			textField.isEnabled = true
			
			textField.reactive.continuousTextValues.observeValues({ (values) in
				if let values = values as String! {
					self.model?.text = values
				}
				
			})
			
			contentView.addSubview(textField)
			contentView.addSubview(titleLabel)
		} else {
			
			
			
			statusSwitch.alpha = 1.0
			statusSwitch.isEnabled = true
			textField.alpha = 0.0
			textField.isEnabled = false
			
			statusSwitch.reactive.isOnValues.observeValues({ (isOn) in
				if let isOn = isOn as Bool! {
					if isOn == true {
						self.model?.text = "private"
					} else {
						self.model?.text = "public"
					}
				}
			})
			
			contentView.addSubview(statusSwitch)
			contentView.addSubview(titleLabel)
		}
		
		setupLayout()
	}
	
	private func setupLayout() {
		if isNameField == true {
			let viewsDictionary = ["title": titleLabel,
			                       "text": textField]
			var constraintsArray = [NSLayoutConstraint]()
			
			constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-|", options: [], metrics: nil, views: viewsDictionary))
			constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[text]-|", options: [], metrics: nil, views: viewsDictionary))
			
			constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-(>=8)-[text(200@700)]-|", options: [], metrics: nil, views: viewsDictionary))
			
			contentView.addConstraints(constraintsArray)
			
		} else {
			let viewsDictionary = ["title": titleLabel,
			                       "switch": statusSwitch]
			var constraintsArray = [NSLayoutConstraint]()
			
			constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-|", options: [], metrics: nil, views: viewsDictionary))
			constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:[switch(30)]", options: [], metrics: nil, views: viewsDictionary))
			constraintsArray.append(NSLayoutConstraint(item: statusSwitch, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
			
			constraintsArray.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-(>=8)-[switch]-|", options: [], metrics: nil, views: viewsDictionary))
			
			contentView.addConstraints(constraintsArray)
		}
	}
}
