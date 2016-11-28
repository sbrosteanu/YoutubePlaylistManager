//
//  PlaylistListResponse.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper

public class PlaylistListResponse: BaseObjectList {
	public typealias `Type` = Playlist
	
	public var items: [Type]!
	public var tokenPagination: TokenPagination!
	public var kind: String = "youtube#playlistListResponse"
	public var nextPageToken: String!
	public var pageInfo: PageInfo!
	public var visitorId: String!
	public var etag: String!
	public var eventId: String!
	public var prevPageToken: String!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		items <- map["items"]
		tokenPagination <- map["tokenPagination"]
		kind <- map["kind"]
		nextPageToken <- map["nextPageToken"]
		pageInfo <- map["pageInfo"]
		visitorId <- map["visitorId"]
		etag <- map["etag"]
		eventId <- map["eventId"]
		prevPageToken <- map["prevPageToken"]
	}
	public required init(arrayLiteral elements: Type...) {
		items = elements
	}
	
	public typealias Iterator = IndexingIterator<[Type]>
	
	public func makeIterator() -> Iterator {
		let objects = items as [Type]
		return objects.makeIterator()
	}
	
	public subscript(position: Int) -> Type {
		return items[position]
	}
}
