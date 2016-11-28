//
//  Thumbnail.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper

public class ThumbnailDetails: ObjectType {
	
	public var medium: Thumbnail!
	public var defaultValue: Thumbnail!
	public var maxres: Thumbnail!
	public var standard: Thumbnail!
	public var high: Thumbnail!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		medium <- map["medium"]
		defaultValue <- map["default"]
		maxres <- map["maxres"]
		standard <- map["standard"]
		high <- map["high"]
	}
}
