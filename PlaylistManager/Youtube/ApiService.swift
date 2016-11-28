//
//  ApiService.swift
//  PlaylistManager
//
//  Created by Stef Brosteanu on 17/11/2016.
//  Copyright © 2016 Stefan Brosteanu. All rights reserved.
//

import Foundation
import Alamofire

protocol ApiService {
	var apiNameInURL: String {
		get
	}
	var apiVersionString: String {
		get
	}
	var fetcher: ApiFetcher {
		get
	}
	
	init()
}

public class ApiFetcher {
	let baseURL = "https://www.googleapis.com"
	public var accessToken: String? {
		didSet {
			if apiKey != nil {
				apiKey = nil
			}
		}
	}
	public var apiKey: String? {
		didSet {
			if accessToken != nil {
				accessToken = nil
			}
		}
	}
	
	func performRequest(method: HTTPMethod, serviceName: String, apiVersion: String, endpoint: String, queryParams: [String: String], postBody: [String: AnyObject]? = nil, completionHandler: @escaping (_ JSON: [String: AnyObject]?, _ error: NSError?) -> ()) {
		
		
		let url = baseURL + "/\(serviceName)/\(apiVersion)/\(endpoint)"
		var finalQueryParams = queryParams
		var headers: [String: String] = [:]
		if accessToken != nil {
			headers.updateValue("Bearer \(accessToken!)", forKey: "Authorization")
		} else if apiKey != nil {
			finalQueryParams.updateValue(apiKey!, forKey: "key")
		}
		
		do {
			let request =  try multiEncodedURLRequest(method: method, URLString: url, URLParameters: finalQueryParams as [String : AnyObject], bodyParameters: postBody, headers: headers)
			Alamofire.request(request as URLRequestConvertible)
				.validate()
				.responseJSON { response in
					switch response.result {
					case .success(let value):
						completionHandler(value as? [String : AnyObject], nil)
					case .failure(let error):
						let alamofireError = error
						if let responseData = response.data {
							do {
								let JSON = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: AnyObject]
								let errJSON = JSON["error"] as! [String: AnyObject]
								let errSpecificsArr = errJSON["errors"] as! [[String: AnyObject]]
								let errSpecifics = errSpecificsArr[0]
								let errorObj = NSError(domain: errSpecifics["domain"] as! String, code: errJSON["code"] as! Int, userInfo: errSpecifics)
								
								completionHandler(nil, errorObj)
							} catch {
								completionHandler(nil, alamofireError as NSError?)
							}
							
						}
					}
			}
		} catch {
			print(error)
		}
	}
	
	private func multiEncodedURLRequest(
		method: HTTPMethod,
		URLString: String,
		URLParameters: [String: AnyObject],
		bodyParameters: [String: AnyObject]?,
		headers: [String: String]) throws  -> URLRequest
	{
		
		
		let urlString = URL(string: URLString)
		
		let urlRequest = URLRequest(url: urlString!)
		let urlEncodedRequest = try URLEncoding.default.encode(urlRequest, with: URLParameters)
		let bodyRequest = try JSONEncoding.default.encode(urlRequest, with: bodyParameters)
		
		
		var compositeRequest = urlEncodedRequest
		
		compositeRequest.httpMethod = method.rawValue
		compositeRequest.httpBody = bodyRequest.httpBody
		for (key, value) in headers {
			compositeRequest.addValue(value, forHTTPHeaderField: key)
		}
		compositeRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		return compositeRequest
	}
	
	
}
