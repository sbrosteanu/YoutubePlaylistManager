//
//  Youtube.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire

public class Youtube: ApiService {
	var apiNameInURL: String = "youtube"
	var apiVersionString: String = "v3"
	
	public let fetcher: ApiFetcher = ApiFetcher()
	
	public required init() {
		
	}
	
	public var userIp: String!
	public var prettyPrint: Bool = true
	public var quotaUser: String!
	public var fields: String!
	public var alt: YoutubeAlt = .Json
	public var pageToken: String!
	public var maxResults: UInt = 50
	public var onBehalfOfContentOwner: String!
	public var channelId: String!
	public var mine: Bool!
	public var regionCode: String!
	public var id: String!
	public var hl: String = "en_US"
	public var playlistId: String!
	public var videoId: String!
	
	
	
	
	public func deletePlaylists(_ id: String, completionHandler: @escaping (_ success: Bool?, _ error: Error?) -> ()) {
		var queryParams = setUpQueryParams()
		queryParams.updateValue(id, forKey: "id")
		if let onBehalfOfContentOwner = onBehalfOfContentOwner {
			queryParams.updateValue(onBehalfOfContentOwner, forKey: "onBehalfOfContentOwner")
		}
		fetcher.performRequest(method: .delete, serviceName: apiNameInURL, apiVersion: apiVersionString, endpoint: "playlists", queryParams: queryParams) { (JSON, error) -> () in
			if error != nil {
				completionHandler(false, error)
			} else {
				completionHandler(true, nil)
			}
		}
	}
	
	public func listPlaylists(_ part: String, completionHandler: @escaping (_ playlistListResponse: PlaylistListResponse?, _ error: Error?) -> ()) {
		var queryParams = setUpQueryParams()
		if let channelId = channelId {
			queryParams.updateValue(channelId, forKey: "channelId")
		}
		if let id = id {
			queryParams.updateValue(id, forKey: "id")
		}
		queryParams.updateValue(hl, forKey: "hl")
		if let onBehalfOfContentOwnerChannel = onBehalfOfContentOwner {
			queryParams.updateValue(onBehalfOfContentOwnerChannel, forKey: "onBehalfOfContentOwnerChannel")
		}
		if let pageToken = pageToken {
			queryParams.updateValue(pageToken, forKey: "pageToken")
		}
		if let mine = mine {
			queryParams.updateValue(mine.toJSONString(), forKey: "mine")
		}
		queryParams.updateValue(maxResults.toJSONString(), forKey: "maxResults")
		if let onBehalfOfContentOwner = onBehalfOfContentOwner {
			queryParams.updateValue(onBehalfOfContentOwner, forKey: "onBehalfOfContentOwner")
		}
		queryParams.updateValue(part, forKey: "part")
		fetcher.performRequest(method: .get ,serviceName: apiNameInURL, apiVersion: apiVersionString, endpoint: "playlists", queryParams: queryParams) { (JSON, error) -> () in
			if error != nil {
				completionHandler(nil, error)
			} else if JSON != nil {
				let playlistListResponse = Mapper<PlaylistListResponse>().map(JSON: JSON!)
				completionHandler(playlistListResponse, nil)
			}
		}
	}
	
	
	public func listPlaylistItems(_ part: String, completionHandler: @escaping (_ playlistItemListResponse: PlaylistItemListResponse?, _ error: Error?) -> ()) {
		var queryParams = setUpQueryParams()
		if let id = id {
			queryParams.updateValue(id, forKey: "id")
		}
		if let playlistId = playlistId {
			queryParams.updateValue(playlistId, forKey: "playlistId")
		}
		if let pageToken = pageToken {
			queryParams.updateValue(pageToken, forKey: "pageToken")
		}
		if let videoId = videoId {
			queryParams.updateValue(videoId, forKey: "videoId")
		}
		queryParams.updateValue(maxResults.toJSONString(), forKey: "maxResults")
		if let onBehalfOfContentOwner = onBehalfOfContentOwner {
			queryParams.updateValue(onBehalfOfContentOwner, forKey: "onBehalfOfContentOwner")
		}
		queryParams.updateValue(part, forKey: "part")
		fetcher.performRequest(method: .get, serviceName: apiNameInURL, apiVersion: apiVersionString, endpoint: "playlistItems", queryParams: queryParams) { (JSON, error) -> () in
			if error != nil {
				completionHandler(nil, error)
			} else if JSON != nil {
				let playlistItemListResponse = Mapper<PlaylistItemListResponse>().map(JSON: JSON!)
				completionHandler(playlistItemListResponse, nil)
			}
		}
	}
	
	
	
	public func updatePlaylists(_ playlist: Playlist, part: String, completionHandler: @escaping (_ playlist: Playlist?, _ error: Error?) -> ()) {
		var queryParams = setUpQueryParams()
		if let onBehalfOfContentOwner = onBehalfOfContentOwner {
			queryParams.updateValue(onBehalfOfContentOwner, forKey: "onBehalfOfContentOwner")
		}
		queryParams.updateValue(part, forKey: "part")
		
		let postBody: [String: AnyObject] = Mapper<Playlist>().toJSON(playlist) as [String: AnyObject]
		
		fetcher.performRequest(method: .put, serviceName: apiNameInURL, apiVersion: apiVersionString, endpoint: "playlists", queryParams: queryParams, postBody: postBody) { (JSON, error) -> () in
			if error != nil {
				completionHandler(nil, error)
			} else if let JSON = JSON {
				let playlist = Mapper<Playlist>().map(JSON: JSON)
				completionHandler(playlist, nil)
			}
		}
	}
	
	public func insertPlaylists(_ playlist: Playlist, part: String, completionHandler: @escaping (_ playlist: Playlist?, _ error: Error?) -> ()) {
		var queryParams = setUpQueryParams()
		if let onBehalfOfContentOwnerChannel = onBehalfOfContentOwner {
			queryParams.updateValue(onBehalfOfContentOwnerChannel, forKey: "onBehalfOfContentOwnerChannel")
		}
		if let onBehalfOfContentOwner = onBehalfOfContentOwner {
			queryParams.updateValue(onBehalfOfContentOwner, forKey: "onBehalfOfContentOwner")
		}
		queryParams.updateValue(part, forKey: "part")
		
		let postBody: [String: AnyObject] = Mapper<Playlist>().toJSON(playlist) as [String: AnyObject]
		
		fetcher.performRequest(method: .post, serviceName: apiNameInURL, apiVersion: apiVersionString, endpoint: "playlists", queryParams: queryParams, postBody: postBody) { (JSON, error) -> () in
			if error != nil {
				completionHandler(nil, error)
			} else if let JSON = JSON {
				let playlist = Mapper<Playlist>().map(JSON: JSON)
				completionHandler(playlist, nil)
			}
		}
	}
	
	/*
	The next few methods are for retrieving the channel title for a video in a playlist.
	Basically I will call the /videos endpoint and with the channel ids retrieved by that, I will call the channels endpoint.
	*/
	
	public func listVideos(_ part: String, completionHandler: @escaping (_ videoListResponse: VideosListResponse?, _ error: Error?) -> ()) {
		var queryParams = setUpQueryParams()
		queryParams.updateValue(part, forKey: "part")
		if let id = id {
			queryParams.updateValue(id, forKey: "id")
		}
		if let pageToken = pageToken {
			queryParams.updateValue(pageToken, forKey: "pageToken")
		}
		queryParams.updateValue(maxResults.toJSONString(), forKey: "maxResults")
		if let onBehalfOfContentOwner = onBehalfOfContentOwner {
			queryParams.updateValue(onBehalfOfContentOwner, forKey: "onBehalfOfContentOwner")
		}
		fetcher.performRequest(method: .get, serviceName: apiNameInURL, apiVersion: apiVersionString, endpoint: "videos", queryParams: queryParams) { (JSON, error) -> () in
			if error != nil {
				completionHandler(nil, error)
			} else if JSON != nil {
				let videoListResponse = Mapper<VideosListResponse>().map(JSON: JSON!)
				completionHandler(videoListResponse, nil)
			}
		}
	}
	
	
	
	func setUpQueryParams() -> [String: String] {
		var queryParams = [String: String]()
		if let userIp = userIp {
			queryParams.updateValue(userIp, forKey: "userIp")
		}
		queryParams.updateValue(prettyPrint.toJSONString(), forKey: "prettyPrint")
		if let quotaUser = quotaUser {
			queryParams.updateValue(quotaUser, forKey: "quotaUser")
		}
		if let fields = fields {
			queryParams.updateValue(fields, forKey: "fields")
		}
		queryParams.updateValue(alt.rawValue, forKey: "alt")
		return queryParams
	}
	
	
}

public enum YoutubeOAuthScopes: String {
	case YoutubePartnerChannelAudit = "https://www.googleapis.com/auth/youtubepartner-channel-audit"
	case Upload = "https://www.googleapis.com/auth/youtube.upload"
	case Youtube = "https://www.googleapis.com/auth/youtube"
	case YoutubePartner = "https://www.googleapis.com/auth/youtubepartner"
	case ForceSSL = "https://www.googleapis.com/auth/youtube.force-ssl"
	case Readonly = "https://www.googleapis.com/auth/youtube.readonly"
}

public enum YoutubeAlt: String {
	case Json = "json"
}

