//
//  PlaylistItemContentDetails.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 18/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import ObjectMapper

public class PlaylistItemContentDetails: ObjectType {
	public var note: String!
	public var videoId: String!
	public var endAt: String!
	public var startAt: String!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		note <- map["note"]
		videoId <- map["videoId"]
		endAt <- map["endAt"]
		startAt <- map["startAt"]
	}
}
