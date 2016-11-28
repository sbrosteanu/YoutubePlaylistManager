//
//  ResourceId.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 25/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import ObjectMapper

public class ResourceId: ObjectType {

	public var channelId: String!
	public var videoId: String!
	public var playlistId: String!
	public var kind: String!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		channelId <- map["channelId"]
		videoId <- map["videoId"]
		playlistId <- map["playlistId"]
		kind <- map["kind"]
	}
	
}
