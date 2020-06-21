//
//  WebLocation.swift
//  ObjectVoice
//
//  Created by James Tice on 2/12/19.
//  Copyright © 2020 ObjectVoice Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class WebLocation : NSObject {
    
    
    public static let OBJECT_KEY: String = "web_location"
    public static let OBJECT_LIST_KEY: String = "web_locations"

    
    var code: String
    var location: String
    var tags_id: Int?
    var type: String?
    var thumbnail_default: String?
    
    
    
    init?(code: String, location: String)  {
        self.code = code
        self.location = location
    }
    
    init?(code: String, location: String, tags_id: Int)  {
        self.code = code
        self.location = location
        self.tags_id = tags_id
    }
    
    static func fromJSON(json: JSON) -> WebLocation?  {
        
        let code : String? = json["code"].string
        let location : String? = json["location"].string
        let tags_id : Int? = json["tags_id"].int
        let thumbnail_default: String? = json["thumbnail_default"].string

        if(code != nil && location != nil) {
            let web_location = WebLocation(code: code!, location: location!)
            if(tags_id != nil)    {
                web_location?.tags_id = tags_id
            }
            if(thumbnail_default != nil)    {
                web_location?.thumbnail_default = thumbnail_default
            }
            return web_location
            
        }
        return nil
    }
    
}