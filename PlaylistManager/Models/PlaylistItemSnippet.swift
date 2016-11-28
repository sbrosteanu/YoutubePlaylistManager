//
//  PlaylistItemSnippet.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 18/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import ObjectMapper

public class PlaylistItemSnippet: ObjectType {

	public var channelId: String!
	public var thumbnails: ThumbnailDetails!
	public var title: String!
	public var playlistId: String!
	public var description: String!
	public var publishedAt: Date!
	public var position: UInt!
	public var channelTitle: String!
	public var resourceId: ResourceId!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		channelId <- map["channelId"]
		thumbnails <- map["thumbnails"]
		title <- map["title"]
		resourceId <- map["resourceId"]
		playlistId <- map["playlistId"]
		description <- map["description"]
		publishedAt <- (map["publishedAt"], RFC3339Transform())
		position <- map["position"]
		channelTitle <- map["channelTitle"]
	}
	
}
