//
//  TagService.swift
//  ObjectVoice
//
//  Created by James Tice on 1/14/19.
//  Copyright © 2020 ObjectVoice Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public class TagService : ObjectVoiceAPIService   {

    var auth: AccountService

    override init() {
        auth = AccountService()
    }
    
    func assignToAccountMap(code: String, completion: ((Int, String)->())?)  {
        
        let endpoint = "/accounts/current/username_tag/object_voices/" + code
        var query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request")
            return
        }
                
        var parameters: Parameters = [
            "code": code,
        ]
        
        let locationService = LocationService()
        var last_location = locationService.getLastLocation()
        
        if let lat = last_location?.coordinate.latitude {
            parameters["lat"] = lat
        }
        if let lon = last_location?.coordinate.longitude {
            parameters["lon"] = lon
        }
        if let altitude = last_location?.altitude {
            parameters["altitude"] = altitude
            parameters["provider"] = "ios-gps"
        }
        if let timestamp = last_location?.timestamp {
            parameters["location_acquired"] = timestamp.timeIntervalSince1970
        }
        if let horizontal_accuracy = last_location?.horizontalAccuracy {
            parameters["accuracy"] = horizontal_accuracy
        }
        if let timestamp = last_location?.timestamp {
            parameters["location_acquired"] = "\(timestamp.timeIntervalSince1970)"
        }
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
            //  "Accept": "application/json"
        ];
        
        Alamofire.request(base, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        completion!(result, message!)
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
                    }
                    
                }
            }
        }
        
    }
    
    func removeFromAccountMap(code: String, completion: ((Int, String)->())?)  {
        
        
        let endpoint = "/accounts/current/username_tag/object_voices/" + code
        var query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request")
            return
        }
        
        let parameters: Parameters = [
            "code": code,
        ]
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
            //  "Accept": "application/json"
        ];
        
        Alamofire.request(base, method: .delete, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        completion!(result, message!)
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
                    }
                    
                }
            }
        }
        
    }

    func getNearbyTags(completion: ((Int, String, [OVTag])->())?)    {
        
        
        
        let endpoint = "/public/tags/nearby"
        var query_string = "?api_key=" + getAPIKey()
        let locationService = LocationService()
        var last_location = locationService.getLastLocation()
        
        if let lat = last_location?.coordinate.latitude {
            query_string = query_string + "&lat=\(lat)"
        }
        if let lon = last_location?.coordinate.longitude {
            query_string = query_string + "&lon=\(lon)"
        }
        if let altitude = last_location?.altitude {
            query_string = query_string + "&altitude=\(altitude)"
        }
        if let timestamp = last_location?.timestamp {
            query_string = query_string + "&location_acquired=\(timestamp.timeIntervalSince1970)"
        }
        if let horizontal_accuracy = last_location?.horizontalAccuracy {
            query_string = query_string + "&accuracy=\(horizontal_accuracy)"
        }
        
        
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", [OVTag]())
            return
        }
        
//        if let brand = PreferencesService.current_brand {
//            base = base + "&brands_id=\(brand.brands_id)"
//        }

            
                
        var parameters: Parameters = [
            //"username": username,
            //"password": password
            :]
        

        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
            //  "Accept": "application/json"
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var tags = [OVTag]()
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let object_voices = json["data"][OVTag.OBJECT_KEY].array
                            for (key, subJson) in json["data"][OVTag.OBJECT_KEY] {
                                if let tag_name = subJson["tag_name"].string {
                                    if let parsed = OVTag.fromJSON(json: subJson)   {
                                        tags.append(parsed)
                                    }
                                }
                            }
                            
                            
                            // self.loadAccount()
                        }
                        completion!(result, message!, tags)
                        // completion!(result, message!)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", tags)
                    }
                    
                }
            }
        }
    }

    
    func getMostPopularTags(completion: ((Int, String, [OVTag])->())?)    {
        return getMostPopularTags(brands_id: nil, completion: completion)
    }

    func getMostPopularTags(brands_id: Int?, completion: ((Int, String, [OVTag])->())?)    {
        
        
        let endpoint = "/public/tags/popular"
        var query_string = "?api_key=" + getAPIKey()
        if let brands_id_unwrapped = brands_id {
            query_string += "&brands_id=\(brands_id_unwrapped)"
        }
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", [OVTag]())
            return
        }
        
        
        var parameters: Parameters = [:]
        

        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var tags = [OVTag]()
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let object_voices = json["data"][OVTag.OBJECT_KEY].array
                            for (key, subJson) in json["data"][OVTag.OBJECT_KEY] {
                                if let tag_name = subJson["tag_name"].string {
                                    if let parsed = OVTag.fromJSON(json: subJson)   {
                                        tags.append(parsed)
                                    }
                                }
                            }
                            
                        }
                        completion!(result, message!, tags)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", tags)
                    }
                    
                }
            }
        }
    }
    
    func searchForNearbyTags(search: String, completion: ((Int, String, [OVTag])->())?)    {
        return searchForNearbyTags(brands_id: nil, search: search, completion: completion)
    }

    func searchForNearbyTags(brands_id: Int?, search: String, completion: ((Int, String, [OVTag])->())?)    {
        
        var filtered_search = search.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "@", with: "").replacingOccurrences(of: "/", with: "")

        
        let endpoint = "/public/tags/search/nearby/" + filtered_search
        var query_string = "?api_key=" + getAPIKey()
        if let brands_id_unwrapped = brands_id {
            query_string += "&brands_id=\(brands_id_unwrapped)"
        }
        
        let locationService = LocationService()
        var last_location = locationService.getLastLocation()
        
        if let lat = last_location?.coordinate.latitude {
            query_string += "&lat=\(lat)"
        }
        if let lon = last_location?.coordinate.longitude {
            query_string += "&lon=\(lon)"
        }
        if let altitude = last_location?.altitude {
            query_string += "&altitude=\(altitude)"
        }
        if let timestamp = last_location?.timestamp {
            query_string += "&location_acquired=\(timestamp.timeIntervalSince1970)"
        }
        if let horizontal_accuracy = last_location?.horizontalAccuracy {
            query_string += "&accuracy=\(horizontal_accuracy)"
        }
        
        
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", [OVTag]())
            return
        }
        
        
        var parameters: Parameters = [
            //"username": username,
            //"password": password
            :]
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
            //  "Accept": "application/json"
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var tags = [OVTag]()
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let object_voices = json["data"][OVTag.OBJECT_KEY].array
                            for (key, subJson) in json["data"][OVTag.OBJECT_KEY] {
                                if let tag_name = subJson["tag_name"].string {
                                    if let parsed = OVTag.fromJSON(json: subJson)   {
                                        tags.append(parsed)
                                    }
                                }
                            }
                            
                                                    }
                        completion!(result, message!, tags)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", tags)
                    }
                    
                }
            }
        }
    }
    
    func searchForTags(search: String, completion: ((Int, String, [OVTag])->())?)    {
        return searchForNearbyTags(brands_id: nil, search: search, completion: completion)
    }
    
    func searchForTags(brands_id: Int?, search: String, completion: ((Int, String, [OVTag])->())?)    {
        
        var filtered_search = search.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "@", with: "").replacingOccurrences(of: "/", with: "")
        
        
        let endpoint = "/public/tags/search/" + filtered_search
        var query_string = "?api_key=" + getAPIKey()
        if let brands_id_unwrapped = brands_id {
            query_string += "&brands_id=\(brands_id_unwrapped)"
        }
        
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", [OVTag]())
            return
        }
        
        
        var parameters: Parameters = [
            //"username": username,
            //"password": password
            :]
        
        /*if let lat = last_location?.coordinate.latitude {
         parameters["lat"] = lat
         }
         if let lon = last_location?.coordinate.longitude {
         parameters["lon"] = lon
         }
         if let altitude = last_location?.altitude {
         parameters["altitude"] = altitude
         }
         if let timestamp = last_location?.timestamp {
         parameters["location_acquired"] = timestamp.timeIntervalSince1970
         }
         if let horizontal_accuracy = last_location?.horizontalAccuracy {
         parameters["accuracy"] = horizontal_accuracy
         }*/
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
            //  "Accept": "application/json"
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {

                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var tags = [OVTag]()
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let object_voices = json["data"][OVTag.OBJECT_KEY].array
                            for (key, subJson) in json["data"][OVTag.OBJECT_KEY] {
                                if let tag_name = subJson["tag_name"].string {
                                    if let parsed = OVTag.fromJSON(json: subJson)   {
                                        tags.append(parsed)
                                    }
                                }
                            }
                            
                                                    }
                        completion!(result, message!, tags)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", tags)
                    }
                    
                }
            }
        }
    }

}
