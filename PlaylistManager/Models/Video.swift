//
//  Video.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 25/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper

public class Video: NSObject, BaseObject {
	
	public var kind: String = "youtube#video"
	public var snippet: VideoSnippet!
	public var etag: String!
	public var id: String!
	
	public required init?(map: Map) {
		
	}
	
	public override init() {
		
	}
	
	public func mapping(map: Map) {
		kind <- map["kind"]
		snippet <- map["snippet"]
		etag <- map["etag"]
		id <- map["id"]
	}
}
