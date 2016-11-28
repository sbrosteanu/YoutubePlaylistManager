//
//  PlaylistStatus.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import ObjectMapper


public class ItemStatus: ObjectType {
	public var privacyStatus: PrivacyStatus!
	
	public required init?(map: Map) {
		
	}
	
	public init() {
		
	}
	
	public func mapping(map: Map) {
		privacyStatus <- map["privacyStatus"]
	}
}

public enum PrivacyStatus: String {
	// Private will be the locked status
	case Private = "private"
	
	case Public = "public"
	
	case Unlisted = "unlisted"
}
