//
//  PlaylistSnippet.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper

public class PlaylistSnippet: ObjectType {
	public var thumbnails: ThumbnailDetails!
	public var channelId: String!
	public var title: String!
	public var tags: [String]!
	public var description: String!
	public var publishedAt: Date!
	public var defaultLanguage: String!
	public var channelTitle: String!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		thumbnails <- map["thumbnails"]
		channelId <- map["channelId"]
		title <- map["title"]
		tags <- map["tags"]
		description <- map["description"]
		publishedAt <- (map["publishedAt"], RFC3339Transform())
		defaultLanguage <- map["defaultLanguage"]
		channelTitle <- map["channelTitle"]
	}
}
