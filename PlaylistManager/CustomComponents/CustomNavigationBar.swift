//
//  CustomNavigationBar.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 28/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
	
	
	///The height you want your navigation bar to be of
	static let navigationBarHeight: CGFloat = 65
	
	///The difference between new height and default height
	static let heightIncrease:CGFloat = navigationBarHeight - 44
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initialize()
	}
	
	private func initialize() {
		let shift = CustomNavigationBar.heightIncrease/2
		self.transform = CGAffineTransform(translationX: 0, y: -shift)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		let shift = CustomNavigationBar.heightIncrease/2
		
		///Move the background down for [shift] point
		
		var classNamesToReposition: [String]
		
		if ProcessInfo().isOperatingSystemAtLeast(OperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)) {
			classNamesToReposition = ["_UIBarBackground"]
		} else {
			classNamesToReposition = ["_UINavigationBarBackground"]
		}

		for view: UIView in self.subviews {
			
			if classNamesToReposition.contains(NSStringFromClass(view.classForCoder)) {
				let bounds: CGRect = self.bounds
				var frame: CGRect = view.frame
				frame.origin.y = bounds.origin.y + shift - 20.0
				frame.size.height = bounds.size.height + 20.0
				view.frame = frame
			}
		}
	}
	
	override func sizeThatFits(_ size: CGSize) -> CGSize {
		let amendedSize:CGSize = super.sizeThatFits(size)
		let newSize: CGSize = CGSize(width: amendedSize.width, height: CustomNavigationBar.navigationBarHeight)
		return newSize;
	}
}
