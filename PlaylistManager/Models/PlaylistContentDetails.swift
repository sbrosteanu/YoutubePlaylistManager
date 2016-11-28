//
//  PlaylistContentDetails.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper

public class PlaylistContentDetails: ObjectType {
	public var itemCount: UInt!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		itemCount <- map["itemCount"]
	}
}
