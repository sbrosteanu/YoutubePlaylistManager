//
//  VideoSnippet.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 25/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import ObjectMapper

public enum YoutubeVideoSnippetLiveBroadcastContent: String {
	case Live = "live"
	case None = "none"
	case Upcoming = "upcoming"
}

public class VideoSnippet: ObjectType {
	
	public var channelId: String!
	public var tags: [String]!
	public var title: String!
	public var defaultAudioLanguage: String!
	public var thumbnails: ThumbnailDetails!
	public var description: String!
	public var categoryId: String!
	public var publishedAt: Date!
	public var defaultLanguage: String!
	public var channelTitle: String!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		channelId <- map["channelId"]
		title <- map["title"]
		defaultAudioLanguage <- map["defaultAudioLanguage"]
		thumbnails <- map["thumbnails"]
		description <- map["description"]
		categoryId <- map["categoryId"]
		publishedAt <- (map["publishedAt"], RFC3339Transform())
		defaultLanguage <- map["defaultLanguage"]
		channelTitle <- map["channelTitle"]
	}
}
