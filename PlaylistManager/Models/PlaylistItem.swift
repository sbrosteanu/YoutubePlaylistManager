//
//  PlaylistItem.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 18/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper

public class PlaylistItem: BaseObject {

	public var contentDetails: PlaylistItemContentDetails!
	public var snippet: PlaylistItemSnippet!
	public var etag: String!
	public var id: String!
	public var status: ItemStatus!
	public var kind: String = "youtube#playlistItem"
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		contentDetails <- map["contentDetails"]
		snippet <- map["snippet"]
		etag <- map["etag"]
		id <- map["id"]
		status <- map["status"]
		kind <- map["kind"]
	}
	
}
