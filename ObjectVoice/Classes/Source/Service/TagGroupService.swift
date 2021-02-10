//
//  TagGroupService.swift
//  ObjectVoice
//
//  Created by James Tice on 1/27/21.
//

import Foundation
import SwiftyJSON
import Alamofire

public class TagGroupService : ObjectVoiceAPIService   {

    var auth: AccountService

    public override init() {
        auth = AccountService()
        super.init()
    }


    public func getNearbyTagGroups(tag_groups_id: Int?, completion: ((Int, String, [OVTagGroup])->())?)  {
        return getNearbyTagGroups(tag_groups_id: tag_groups_id, radius: nil, completion: completion)
    }


    public func getNearbyTagGroups(tag_groups_id: Int?, radius: Int?, completion: ((Int, String, [OVTagGroup])->())?)  {

        let endpoint = "/public/tag_groups/proximity"
        var query_string = "?api_key=" + getAPIKey()
        let locationService = LocationService()
        let last_location = locationService.getLastLocation()

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
        if let rad = radius  {
            query_string = query_string + "&radius=\(rad)"
        }
        if let tgid = tag_groups_id  {
            query_string = query_string + "&parent_id=\(tgid)"
        }


        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", [OVTagGroup]())
            return
        }

//        if let brand = PreferencesService.current_brand {
//            base = base + "&brands_id=\(brand.brands_id)"
//        }



        let parameters: Parameters = [:]


        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
        ];

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, encoding: JSONEncoding(options: []), headers: headers).response  { response in

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var tags = [OVTagGroup]()

                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue

                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            for (key, subJson) in json["data"][OVTagGroup.OBJECT_KEY] {
                                if let tag_name = subJson["name"].string {
                                    if let parsed = OVTagGroup.fromJSON(json: subJson)   {
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

    public func getTagGroupById(tag_groups_id: Int, completion: ((Int, String, OVTagGroup?)->())?)    {

        let endpoint = "/public/tag_groups/\(tag_groups_id)"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", nil)
            return
        }


        let parameters: Parameters = [:]

        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)"
        ];

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var group: OVTagGroup?

                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue

                    if let message = json["message"].string    {
                        if(result == 1) {
                            group = OVTagGroup.fromJSON(json: json["data"][OVTagGroup.OBJECT_KEY])
                        }
                        completion!(result, message, group)

                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", group)
                    }

                }
            }
        }
    }

    public func getTagGroupsByIds(tag_groups_ids: [Int], completion: ((Int, String, [OVTagGroup])->())?)    {

        var id_str = ""
        for id in tag_groups_ids  {
            if !id_str.isEmpty   {
                id_str += ","
            }
            id_str += "\(id)"
        }
        if id_str == "" {
            completion!(1, "Empty id list", [OVTagGroup]())
            return
        }


        let endpoint = "/public/tag_groups/\(id_str)"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", [OVTagGroup]())
            return
        }



        let parameters: Parameters = [:]

        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)"
        ];

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var groups = [OVTagGroup]()

                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue

                    if let message = json["message"].string    {
                        if(result == 1) {
                            if !json["data"][OVTagGroup.OBJECT_KEY]["name"].exists() {
                                for (key, subJson) in json["data"][OVTagGroup.OBJECT_KEY] {
                                    if let tag_name = subJson["name"].string {
                                        if let parsed = OVTagGroup.fromJSON(json: subJson) {
                                            groups.append(parsed)
                                        }
                                    }
                                }
                            }   else    {
                                if let parsed = OVTagGroup.fromJSON(json: json["data"][OVTagGroup.OBJECT_KEY]) {
                                    groups.append(parsed)
                                }
                            }

                            completion!(result, message, groups)
                        }
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", groups)
                    }

                }
            }
        }
    }

    public func searchForTagGroups(search: String, completion: ((Int, String, [OVTagGroup])->())?)    {
        return searchForTagGroups(brands_id: nil, search: search, completion: completion)
    }

    public func searchForTagGroups(brands_id: Int?, search: String, completion: ((Int, String, [OVTagGroup])->())?)    {

        let filtered_search = search.replacingOccurrences(of: "#", with: "").replacingOccurrences(of: "@", with: "").replacingOccurrences(of: "/", with: "")


        let endpoint = "/public/tag_groups/search/" + filtered_search
        var query_string = "?api_key=" + getAPIKey()
        if let brands_id_unwrapped = brands_id {
            query_string += "&brands_id=\(brands_id_unwrapped)"
        }

        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", [OVTagGroup]())
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
                var tags = [OVTagGroup]()

                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue

                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let object_voices = json["data"][OVTagGroup.OBJECT_KEY].array
                            for (key, subJson) in json["data"][OVTagGroup.OBJECT_KEY] {
                                if let tag_name = subJson["name"].string {
                                    if let parsed = OVTagGroup.fromJSON(json: subJson)   {
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
