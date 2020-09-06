//
//  APIService.swift
//  ObjectVoice
//
//  Created by James Tice on 5/1/20.
//  Copyright © 2020 ObjectVoice Inc. All rights reserved.
//

import Foundation

public class ObjectVoiceAPIService    {
    
    private static let KEY_DEVICE_ID = "ov_device_id"
    private static var api_key = ""
    private static var api_domain = "api.objectvoice.com"
    private static var api_directory = "/api/v2"
    private static var device_id = ""
    
    public init()   {
        if ObjectVoiceAPIService.device_id == ""   {
            ObjectVoiceAPIService.loadDeviceId()
        }
    }
    
    private static func loadDeviceId()    {
        let defaults = UserDefaults.standard
        let loaded_id = defaults.object(forKey: ObjectVoiceAPIService.KEY_DEVICE_ID) as? String ?? String()
        if loaded_id == ""  {
            ObjectVoiceAPIService.device_id = UUID().uuidString
            defaults.set(ObjectVoiceAPIService.device_id, forKey: ObjectVoiceAPIService.KEY_DEVICE_ID)
            defaults.synchronize()
        }   else    {
            ObjectVoiceAPIService.device_id = loaded_id
        }
    }
    
    public func getDeviceId() -> String    {
        return ObjectVoiceAPIService.device_id
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
    
    public static func setAPIDomain(domain: String)    {
        ObjectVoiceAPIService.api_domain = domain
    }
    
    public static func setAPIDirectory(directory: String)    {
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
