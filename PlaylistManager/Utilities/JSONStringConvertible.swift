//
//  JSONStringConvertible.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation

protocol JSONStringConvertible {
	func toJSONString() -> String
}

extension Bool: JSONStringConvertible {
	func toJSONString() -> String {
		if self == true {
			return "true"
		} else {
			return "false"
		}
	}
}

extension Int: JSONStringConvertible {
	func toJSONString() -> String {
		return "\(self)"
	}
}

extension UInt: JSONStringConvertible {
	func toJSONString() -> String {
		return "\(self)"
	}
}

extension Date: JSONStringConvertible {
	func toJSONString() -> String {
		if let dateString = RFC3339Transform().transformToJSON(self) {
			return dateString
		} else {
			return ""
		}
	}
}

extension UInt64: JSONStringConvertible {
	func toJSONString() -> String {
		return "\(self)"
	}
}
