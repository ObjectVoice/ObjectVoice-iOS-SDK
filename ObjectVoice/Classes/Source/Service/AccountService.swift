//
//  AccountService.swift
//  ObjectVoice
//
//  Created by James Tice on 6/2/18.
//  Copyright © 2018 ObjectVoice Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class AccountService : ObjectVoiceAPIService   {
    
    var jwt: String
    var logged_in: Bool
    var account_id: Int
    var username: String
    var role: String
    var agreed_tos: Bool
    var needs_account_setup: Bool
    
    public static let KEY_ACCOUNT_ID = "ov_account_id"
    public static let KEY_LOGGED_IN = "ov_logged_in"
    public static let KEY_JWT = "ov_jwt"
    public static let KEY_USERNAME = "ov_username"
    public static let KEY_ROLE = "ov_role"
    public static let KEY_AGREED_TOS = "ov_agreed_tos"
    public static let KEY_NEEDS_ACCOUNT_SETUP = "ov_needs_account_setup"
    
    override init() {
        let defaults = UserDefaults.standard
        self.account_id = defaults.integer(forKey: AccountService.KEY_ACCOUNT_ID)
        self.logged_in = defaults.bool(forKey: AccountService.KEY_LOGGED_IN)
        self.jwt = defaults.object(forKey: AccountService.KEY_JWT) as? String ?? String()
        self.username = defaults.object(forKey: AccountService.KEY_USERNAME) as? String ?? String()
        self.role = defaults.object(forKey: AccountService.KEY_ROLE) as? String ?? String()
        self.agreed_tos = defaults.bool(forKey: AccountService.KEY_AGREED_TOS)
        self.needs_account_setup = defaults.bool(forKey: AccountService.KEY_NEEDS_ACCOUNT_SETUP)
        
    }
    
    func setTOSAgreed() {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: AccountService.KEY_AGREED_TOS)
        self.loadAccount()
    }
    
    func loadAccount()  {
        let defaults = UserDefaults.standard
        self.account_id = defaults.integer(forKey: AccountService.KEY_ACCOUNT_ID)
        self.logged_in = defaults.bool(forKey: AccountService.KEY_LOGGED_IN)
        self.jwt = defaults.object(forKey: AccountService.KEY_JWT) as? String ?? String()
        self.username = defaults.object(forKey: AccountService.KEY_USERNAME) as? String ?? String()
        self.role = defaults.object(forKey: AccountService.KEY_ROLE) as? String ?? String()
        self.agreed_tos = defaults.bool(forKey: AccountService.KEY_AGREED_TOS)

    }
    
    func clearAccount() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: AccountService.KEY_ACCOUNT_ID)
        defaults.removeObject(forKey: AccountService.KEY_LOGGED_IN)
        defaults.removeObject(forKey: AccountService.KEY_JWT)
        defaults.removeObject(forKey: AccountService.KEY_ROLE)
        defaults.removeObject(forKey: AccountService.KEY_USERNAME)
        defaults.removeObject(forKey: AccountService.KEY_NEEDS_ACCOUNT_SETUP)

        defaults.synchronize()
        self.loadAccount()


        var base = "https://" + getAPIDomain() + "/"
        guard let url = URL(string: base) else { return }
//        let cstorage = HTTPCookieStorage.shared
//        cstorage.removeCookies(since: Date(timeIntervalSince1970: 0))
        self.removeCookies()

    }
    
    func removeCookies(){
        let cookieJar = HTTPCookieStorage.shared
        if let cookies = cookieJar.cookies  {
            for cookie in cookies {
                if(cookie.domain.lowercased() == getAPIDomain().lowercased())   {
                    cookieJar.deleteCookie(cookie)
                }
            }
        }
    }
    
    
    func accountLogin(username: String, password: String, completion: ((Int, String)->())?)  {
        

        let endpoint = "/login"
        var query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request")
            return
        }
        
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        let headers: HTTPHeaders = [:];
        
        Alamofire.request(base, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let defaults = UserDefaults.standard
                            defaults.set(json["data"][Account.OBJECT_KEY]["account_id"].intValue, forKey: AccountService.KEY_ACCOUNT_ID)
                            defaults.set(json["data"][Account.OBJECT_KEY]["username"].stringValue, forKey: AccountService.KEY_USERNAME)
                            defaults.set(json["data"][Account.OBJECT_KEY]["role"].stringValue, forKey: AccountService.KEY_ROLE)
                            defaults.set(true, forKey: AccountService.KEY_LOGGED_IN)
                            defaults.set(json["data"]["jwt"].string ?? "", forKey: AccountService.KEY_JWT)
                            defaults.set(true, forKey: AccountService.KEY_AGREED_TOS)
                            defaults.set((json["data"][Account.OBJECT_KEY]["username"].stringValue == "New-User-\(json["data"][Account.OBJECT_KEY]["account_id"].intValue)"), forKey: AccountService.KEY_NEEDS_ACCOUNT_SETUP)
                            defaults.synchronize()
                            self.loadAccount()
                        }
                        completion!(result, message!)
                        
                    }   else    {
                         completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
                    }
                    
                }
            }
        }
        
    }
    
    func accountRegister(username: String?, password: String?, completion: ((Int, String)->())?)    {
        

        let endpoint = "/register"
        var query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request")
            return
        }
        
        var param_username = ""
        var param_password = ""

        if let name = username  {
            param_username = name
        }
        
        if let pass = password  {
            param_password = pass
        }
        
        
        let parameters: Parameters = [
            "username": param_username,
            "password": param_password
        ]
        
        let headers: HTTPHeaders = [:];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        
        Alamofire.request(base, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false

            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let defaults = UserDefaults.standard
                            defaults.set(json["data"][Account.OBJECT_KEY]["account_id"].intValue, forKey: AccountService.KEY_ACCOUNT_ID)
                            defaults.set(json["data"][Account.OBJECT_KEY]["username"].stringValue, forKey: AccountService.KEY_USERNAME)
                            defaults.set(json["data"][Account.OBJECT_KEY]["role"].stringValue, forKey: AccountService.KEY_ROLE)
                            defaults.set(true, forKey: AccountService.KEY_LOGGED_IN)
                            defaults.set(json["data"]["jwt"].string ?? "", forKey: AccountService.KEY_JWT)
                            defaults.set(true, forKey: AccountService.KEY_AGREED_TOS)
                            defaults.set((json["data"][Account.OBJECT_KEY]["username"].stringValue == "New-User-\(json["data"][Account.OBJECT_KEY]["account_id"].intValue)"), forKey: AccountService.KEY_NEEDS_ACCOUNT_SETUP)
                            defaults.synchronize()
                            self.loadAccount()
                        }
                        completion!(result, message!)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
                    }
                    
                }
            }
        }
    }
    
    func setAccountDetails(username: String, password: String, completion: ((Int, String)->())?)    {
        
        
        let endpoint = "/accounts/current"
        var query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request")
            return
        }
        
        let parameters: Parameters = [
            "username": username,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(self.jwt)",
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        
        Alamofire.request(base, method: .patch, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let defaults = UserDefaults.standard
                            defaults.set(json["data"][Account.OBJECT_KEY]["account_id"].intValue, forKey: AccountService.KEY_ACCOUNT_ID)
                            defaults.set(json["data"][Account.OBJECT_KEY]["username"].stringValue, forKey: AccountService.KEY_USERNAME)
                            defaults.set(json["data"][Account.OBJECT_KEY]["role"].stringValue, forKey: AccountService.KEY_ROLE)
                            defaults.set(true, forKey: AccountService.KEY_LOGGED_IN)
                            defaults.set(json["data"]["jwt"].string ?? "", forKey: AccountService.KEY_JWT)
                            defaults.set(true, forKey: AccountService.KEY_AGREED_TOS)
                            defaults.set(false, forKey: AccountService.KEY_NEEDS_ACCOUNT_SETUP)
                            defaults.synchronize()
                            self.loadAccount()
                        }
                        completion!(result, message!)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
                    }
                    
                }
            }
        }
    }
    
}
