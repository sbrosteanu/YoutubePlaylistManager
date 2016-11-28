//
//  Thumbnail.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper

public class Thumbnail: ObjectType {
	public var width: UInt!
	public var height: UInt!
	public var url: String!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		width <- map["width"]
		height <- map["height"]
		url <- map["url"]
	}
}
