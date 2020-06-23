//
//  Brand.swift
//  ObjectVoice
//
//  Created by James Tice on 7/1/19.
//  Copyright © 2020 ObjectVoice Incs. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Brand : Codable {
    
    
//    protected $brands_id = -1;
//    protected $brand_name = '';
//    protected $brand_logo = '';
//    protected $color_header_text = '#FFFFFF';
//    protected $color_detail_text = '#FFFFFF';
//    protected $color_primary_background = '#FFFFFF';
//    protected $color_secondary_background = '#FFFFFF';
//    protected $tags = array();
//    protected $tags_ids = array();

    
    public var brands_id: Int
    public var brand_name: String
    public var brand_logo: String
    public var color_header_text: String
    public var color_detail_text: String
    public var color_primary_background: String
    public var color_secondary_background: String
    public var should_persist: Bool = false
    public var trigger_state: String = "HOME"
    public var tags_ids: [Int] = [Int]()
    public var tags: [OVTag] = [OVTag]()
    
    public static let TRIGGER_STATE_HOME: String = "HOME"
    public static let TRIGGER_STATE_MAPS: String = "MAPS"
    
    enum CodingKeys: String, CodingKey {
        case brands_id
        case brand_name
        case brand_logo
        case color_header_text
        case color_detail_text
        case color_primary_background
        case color_secondary_background
        case should_persist
        case trigger_state
        case tags_ids
        case tags
    }

    

    public init(brands_id: Int, brand_name: String,  brand_logo: String, color_header_text: String, color_detail_text: String, color_primary_background: String, color_secondary_background: String, should_persist: Bool, trigger_state: String, tags_ids: [Int], tags: [OVTag])  {
        self.brands_id = brands_id
        self.brand_name = brand_name
        self.brand_logo = brand_logo
        self.color_header_text = color_header_text
        self.color_detail_text = color_detail_text
        self.color_primary_background = color_primary_background
        self.color_secondary_background = color_secondary_background
        self.tags_ids = tags_ids
        self.tags = tags
        self.should_persist = should_persist
        self.trigger_state = trigger_state
    }
    
    public init(brands_id: Int, brand_name: String,  brand_logo: String, color_header_text: String, color_detail_text: String, color_primary_background: String, color_secondary_background: String)  {
        self.brands_id = brands_id
        self.brand_name = brand_name
        self.brand_logo = brand_logo
        self.color_header_text = color_header_text
        self.color_detail_text = color_detail_text
        self.color_primary_background = color_primary_background
        self.color_secondary_background = color_secondary_background
    }
    
    public static func fromJSON(json: JSON) -> Brand?  {
        
        let brands_id : Int? = json["brands_id"].int
        let brand_name : String? = json["brand_name"].string
        let brand_logo : String? = json["brand_logo"].string
        var color_header_text : String? = json["color_header_text"].string
        var color_detail_text : String? = json["color_detail_text"].string
        var color_primary_background : String? = json["color_primary_background"].string
        var color_secondary_background : String? = json["color_secondary_background"].string
        var should_persist : Bool? = json["should_persist"].bool
        var trigger_state : String? = json["trigger_state"].string
        var tags_ids: [Int] = [Int]()
        var tags: [OVTag] = [OVTag]()
        
        
        for (key, subJson) in json["tags"] {
            let ov_tag = OVTag.fromJSON(json: subJson)
            if(ov_tag != nil)    {
                tags.append(ov_tag!)
            }
        }
        for (key, val) in json["tags_ids"] {
            let tags_id: Int? = val.int
            if(tags_id != nil)    {
                tags_ids.append(tags_id!)
            }
        }
        
        if(color_header_text == nil)    {
            color_header_text = "#000000";
        }
        if(color_detail_text == nil)    {
            color_detail_text = "#000000";
        }
        if(color_primary_background == nil)    {
            color_primary_background = "#000000";
        }
        if(color_secondary_background == nil)    {
            color_secondary_background = "#000000";
        }

        if(brands_id != nil) {
            let brand = Brand(brands_id: brands_id!, brand_name: brand_name!, brand_logo: brand_logo!, color_header_text: color_header_text!, color_detail_text: color_detail_text!, color_primary_background: color_primary_background!, color_secondary_background: color_secondary_background!, should_persist: should_persist!, trigger_state: trigger_state!, tags_ids: tags_ids, tags: tags)
            
            return brand
            
        }
        return nil
    }
    
}
