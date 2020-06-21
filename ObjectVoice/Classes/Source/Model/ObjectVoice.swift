//
//  ObjectVoice.swift
//  ObjectVoice
//
//  Created by James Tice on 2/19/18.
//  Copyright © 2020 ObjectVoice Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

class ObjectVoice {
    
//    private String code = "";
//    private int accountId = -1;
//    private ArrayList<String> locations;
//    private String mimetype = "";
//    private String visibility = "";
//    private Date created = null;
//    private Date firstAssigned = null;
//    private Date lastAssigned = null;
    
    public static let OBJECT_KEY: String = "object_voice"
    public static let OBJECT_LIST_KEY: String = "object_voices"
    
    public static let CATEGORY_STANDARD: String = "STANDARD"
    public static let CATEGORY_PREMIUM: String = "PREMIUM"
    
    var code: String
    var accountId: Int?
    var web_locations: [WebLocation] = [WebLocation]()
    var mimetype: String?
    var visibility: String
    var created: Date?
    var firstAssigned: Date?
    var lastAssigned: Date?
    var lat: Double?
    var lon: Double?
    var scans: Int?
    var clears_remaining: Int?
    var category: String?
    var tags: [OVTag] = [OVTag]()
    var account: Account?
    
    
    init?(code: String)  {
        self.code = code
        self.visibility = "public"
    }
    
    
    init?(code: String, accountId: Int, web_locations: [WebLocation], mimetype: String, visibility: String, created: Date?, firstAssigned: Date?, lastAssigned: Date?)  {
        if(code.isEmpty || created == nil)  {
            return nil;
        }
        self.code = code
        self.accountId = accountId
        self.web_locations = web_locations
        self.mimetype = mimetype
        self.visibility = visibility
        self.created = created
        self.firstAssigned = firstAssigned
        self.lastAssigned = lastAssigned
    }
    
    static func fromJSON(json: JSON) -> ObjectVoice?  {
        
        //let json = JSON(parseJSON: rawTextResponse)
        //var result = -1
        
      //  if json["data"]["result"].intValue == 1 || json["data"]["result"].intValue == 0 {
            //result = json["data"]["result"].intValue
            
        let code : String? = json["code"].string
        let visibility : String? = json["visibility"].string
        let lat : Double? = json["lat"].double
        let lon : Double? = json["lon"].double
        let account_id : Int? = json["account_id"].int
        let scans : Int? = json["scans"].int
        let clears_remaining : Int? = json["clears_remaining"].int
        let mimetype : String? = json["mimetype"].string
        let created : String? = json["created"].string
        let first_assigned : String? = json["first_assigned"].string
        let last_assigned : String? = json["last_assigned"].string
        let category : String? = json["category"].string
        var tags: [OVTag] = [OVTag]()
        var locations: [WebLocation] = [WebLocation]()

        
        for (key, subJson) in json[OVTag.OBJECT_KEY] {
            let ov_tag = OVTag.fromJSON(json: subJson)
            if(ov_tag != nil)    {
                tags.append(ov_tag!)
            }
        }
        for (key, subJson) in json[WebLocation.OBJECT_KEY] {
            let loc = WebLocation.fromJSON(json: subJson)
            if(loc != nil)    {
                locations.append(loc!)
            }
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        if(code != nil) {
            let object_voice = ObjectVoice(code: code!)
            if(visibility != nil)   {
                object_voice?.visibility = visibility!
            }
            
            if(lat != nil)  {
                object_voice?.lat = lat
            }
            if(lon !=  nil) {
                object_voice?.lon = lon
            }
            if(account_id != nil)   {
                object_voice?.accountId = account_id
            }
            if(scans != nil)    {
                object_voice?.scans = scans
            }
            if(locations != nil)    {
                object_voice?.web_locations = locations
            }
            if(mimetype != nil) {
                object_voice?.mimetype = mimetype!
            }
            if(clears_remaining != nil) {
                object_voice?.clears_remaining = clears_remaining!
            }
            if(category != nil) {
                object_voice?.category = category!
            }
            if(created != nil)  {
                object_voice?.created = formatter.date(from: created! + " GMT")
                //add this later
            }
            if(first_assigned != nil)   {
                object_voice?.firstAssigned = formatter.date(from: first_assigned! + " GMT")
                //TODO
            }
            if(last_assigned != nil)    {
                object_voice?.lastAssigned = formatter.date(from: last_assigned! + " GMT")
                //TODO
            }
            object_voice?.tags = tags
            object_voice?.account = Account.fromJSON(json: json["account"])
            
            return object_voice
            
        }
        
        
        //let message :String? = json["data"]["message"].string
        //if(message != nil)  {
            //completion!(result, message!)
       // }   else    {
           // completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
       // }
            
        //}
        
        
        return nil
    }
    
    func getWebLocationForTag(tags_id: Int) -> WebLocation? {
        for webLocation in self.web_locations {
            if let t_id = webLocation.tags_id   {
                if(t_id == tags_id) {
                    return webLocation
                }
            }
        }
        return nil
    }
    
    func getDefaultWebLocation() -> WebLocation? {
        for webLocation in self.web_locations {
            if(webLocation.tags_id == nil)  {
                return webLocation
            }
        }
        if(self.web_locations.count > 0) {
            return self.web_locations[0]
        }
        return nil
    }
    
    
}
