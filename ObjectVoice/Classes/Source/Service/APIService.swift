//
//  APIService.swift
//  ObjectVoice
//
//  Created by James Tice on 5/1/20.
//  Copyright © 2020 ObjectVoice Inc. All rights reserved.
//

import Foundation

public class ObjectVoiceAPIService    {
    
    private static var api_key = ""
    private static var api_domain = "api.objectvoice.com"
    private static var api_directory = "/api/v2"
    
    public init()   {
        
    }

    public func getAPIKey() -> String    {
        return ObjectVoiceAPIService.api_key
    }
    
    public static func setAPIKey(key: String)   {
        ObjectVoiceAPIService.api_key = key
    }
    
    public func getAPIDomain() -> String    {
        return ObjectVoiceAPIService.api_domain
    }
    
    public func setAPIDomain(domain: String)    {
        ObjectVoiceAPIService.api_domain = domain
    }
    
    public func setAPIDirectory(directory: String)    {
        ObjectVoiceAPIService.api_directory = directory
    }
    
    public func getAPIDirectory() -> String    {
        return ObjectVoiceAPIService.api_directory
    }
    
    public func getAPIPath() -> String  {
        return "https://" + getAPIDomain() + getAPIDirectory()
    }
    
    public func getURLString(endpoint: String, query_string: String) -> String {
        return getAPIPath() + endpoint + query_string
    }

}
