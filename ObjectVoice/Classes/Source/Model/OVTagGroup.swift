//
//  OVTagGroup.swift
//  ObjectVoice
//
//  Created by James Tice on 1/27/21.
//

import Foundation
import SwiftyJSON

public class OVTagGroup : Codable {


    public var name: String
    public var tag_groups_id: Int?
    public var badge: Badge?
    public var date_created: Date?
    public var last_updated: Date?

    public static let OBJECT_KEY: String = "tag_group"
    public static let OBJECT_LIST_KEY: String = "tag_groups"


    enum CodingKeys: String, CodingKey {
        case name
        case tag_groups_id
        case badge
        case date_created
        case last_updated
    }

    public init(name: String)  {
        self.name = name
    }
    public init()  {
        self.name = ""
    }

    public init?(name: String, tag_groups_id: Int)  {
        self.name = name
        self.tag_groups_id = tag_groups_id

    }

    public init(name: String, tag_groups_id: Int?, popularity: Int?, object_voice_count: Int?, badge: Badge?) {
        self.name = name
        self.tag_groups_id = tag_groups_id
        self.badge = badge

    }

    public static func fromJSON(json: JSON) -> OVTagGroup?  {

        let name : String? = json["name"].string
        let tag_groups_id : Int? = json["tag_groups_id"].int
        let date_created : String? = json["date_created"].string
        let last_updated : String? = json["last_updated"].string

        var tag_group = OVTagGroup()

        if let n = name {
            tag_group = OVTagGroup(name: n)
        }   else    {
            return nil
        }

        if let tgid = tag_groups_id {
            tag_group.tag_groups_id = tgid
        }

        let badgeJson = json[Badge.OBJECT_KEY]

        if badgeJson != JSON.null {
            tag_group.badge = Badge.fromJSON(json: badgeJson)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"

        if let created = date_created  {
            tag_group.date_created = formatter.date(from: created + " GMT")
        }

        if let updated = last_updated  {
            tag_group.last_updated = formatter.date(from: updated + " GMT")
        }


        return tag_group

    }

}