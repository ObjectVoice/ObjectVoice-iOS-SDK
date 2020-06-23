//
//  OVTag.swift
//  ObjectVoice
//
//  Created by James Tice on 1/14/19.
//  Copyright © 2020 Matthew Walker. All rights reserved.
//

import Foundation
import SwiftyJSON

public class OVTag : Codable {
    
    
    public var tag_name: String
    public var tags_id: Int?
    public var popularity: Int?
    public var object_voice_count: Int?
    public var remote_content_access: String
    public var badge: Badge?
    
    public static let REMOTE_CONTENT_YES: String = "yes"
    public static let REMOTE_CONTENT_NO: String = "no"
    public static let REMOTE_CONTENT_PROXIMITY: String = "proximity"

    
    public static let OBJECT_KEY: String = "tag"
    public static let OBJECT_LIST_KEY: String = "tags"

    
    enum CodingKeys: String, CodingKey {
        case tag_name
        case tags_id
        case popularity
        case object_voice_count
        case badge
        case remote_content_access
    }
    
    public init(tag_name: String)  {
        self.tag_name = tag_name
        self.remote_content_access = "no"
    }
    public init()  {
        self.tag_name = ""
        self.remote_content_access = "no"
    }
    
    public init?(tag_name: String, tags_id: Int)  {
        self.tag_name = tag_name
        self.tags_id = tags_id
        self.remote_content_access = "no"

    }
    
    public init(tag_name: String, tags_id: Int?, popularity: Int?, object_voice_count: Int?, badge: Badge?) {
        self.tag_name = tag_name
        self.tags_id = tags_id
        self.popularity = popularity
        self.object_voice_count = object_voice_count
        self.badge = badge
        self.remote_content_access = "no"

    }
    
    public static func fromJSON(json: JSON) -> OVTag?  {
        
        let tag_name : String? = json["tag_name"].string
        let tags_id : Int? = json["tags_id"].int
        let popularity : Int? = json["popularity"].int
        let object_voice_count : Int? = json["object_voice_count"].int
        let remote_content_access : String? = json["remote_content_access"].string

        var tag = OVTag()
        
        if(tag_name != nil) {
            tag = OVTag(tag_name: tag_name!)
        }   else    {
            return nil
        }

        if(tags_id != nil) {
            tag.tags_id = tags_id
        }
        if(popularity != nil) {
            tag.popularity = popularity
        }
        if(object_voice_count != nil) {
            tag.object_voice_count = object_voice_count
        }
        
        if(json[Badge.OBJECT_KEY] != nil)    {
            tag.badge = Badge.fromJSON(json: json[Badge.OBJECT_KEY])
        }
        if(remote_content_access != nil)    {
            tag.remote_content_access = remote_content_access!
        }
        
        
        return tag

    }
    
}
