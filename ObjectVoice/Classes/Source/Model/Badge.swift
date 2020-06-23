//
//  Badge.swift
//  ObjectVoice
//
//  Created by James Tice on 1/14/19.
//  Copyright © 2020 ObjectVoice Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Badge : Codable {
    
    var primary_url: String
    var badges_id: Int?
    
    public static let OBJECT_KEY: String = "badge"
    public static let OBJECT_LIST_KEY: String = "badges"

    
    enum CodingKeys: String, CodingKey {
        case primary_url
        case badges_id
    }
    
    init(primary_url: String, badges_id: Int) {
        self.primary_url = primary_url
        self.badges_id = badges_id
    }
    
    init?(primary_url: String)  {
        self.primary_url = primary_url
    }
    
    static func fromJSON(json: JSON) -> Badge?  {
        
        let primary_url : String? = json["primary_url"].string
        let badges_id : Int? = json["badges_id"].int
        
        if(primary_url != nil) {
            let badge = Badge(primary_url: primary_url!)
            if(badges_id != nil)    {
                badge?.badges_id = badges_id
            }
            return badge
            
        }
        return nil
    }

}
