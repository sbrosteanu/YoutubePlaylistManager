//
//  Playlist.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper

/// The Playlist model for use with the Youtube API
public class Playlist: BaseObject {
	
	public var id: String!
	public var kind: String = "youtube#playlist"
	public var contentDetails: PlaylistContentDetails!
	public var snippet: PlaylistSnippet!
	public var etag: String!
	public var status: ItemStatus!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		id <- map["id"]
//		player <- map["player"]
		kind <- map["kind"]
		contentDetails <- map["contentDetails"]
//		localizations <- map["localizations"]
		snippet <- map["snippet"]
		etag <- map["etag"]
		status <- map["status"]
	}
}
