//
//  Account.swift
//  ObjectVoice
//
//  Created by James Tice on 1/29/19.
//  Copyright © 2020 ObjectVoice Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Account {
    
    
    var username: String?
    var account_id: Int?
    var role: String?
    
    public static let OBJECT_KEY: String = "account"
    public static let OBJECT_LIST_KEY: String = "account"
    
    init?(username: String, account_id: Int, role: String)  {
        self.username = username
        self.account_id = account_id
        self.role = role
    }
    
    init?() {
        
    }
        
    static func fromJSON(json: JSON) -> Account?  {
        
        let username : String? = json["username"].string
        let account_id : Int? = json["account_id"].int
        let role : String? = json["role"].string
        
        var acc = Account()
        
        if(account_id != nil && username != nil && role != nil) {
            acc = Account(username: username!, account_id: account_id!, role: role!)
        }   else    {
            return nil
        }
        
        return acc
        
    }
    
}
