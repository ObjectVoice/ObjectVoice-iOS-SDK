//
//  BrandService.swift
//  ObjectVoice
//
//  Created by James Tice on 7/1/19.
//  Copyright © 2020 ObjectVoice Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import MobileCoreServices

public class BrandService : ObjectVoiceAPIService   {
    
    public static var brands_id: Int = -1
    public static var scan_mode: String = "CONTENT"
    public static var next_scan: String = "CONTENT"
    public static var pending_code: String = ""
    var auth: AccountService

    
    public override init() {
        auth = AccountService()
    }

    public func create(brand: Brand, completion: ((Int, String, Brand?)->())?)  {
        auth = AccountService()
        
        
        let endpoint = "/brands"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", nil)
            return
        }
        
                
        let parameters: Parameters = [
            "brand_name": brand.brand_name,
            "brand_logo": brand.brand_logo,
            "color_header_text": brand.color_header_text,
            "color_detail_text": brand.color_detail_text,
            "color_primary_background": brand.color_primary_background,
            "color_secondary_background": brand.color_secondary_background,
        ]
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
        ];
        
        
        
        Alamofire.request(base, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var brand: Brand? = nil
                
                if json["data"]["result"].intValue == 1 || json["data"]["result"].intValue == 0 {
                    result = json["data"]["result"].intValue
                    
                    let message :String? = json["data"]["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            brand = Brand.fromJSON(json: json["data"]["brand"])
                        }
                        completion!(result, message!, brand)
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", nil)
                    }
                    
                }
            }
        }
        
    }
    

    public func getBrandForId(brands_id: Int, completion: ((Int, String, Brand?)->())?)    {
        
        auth = AccountService()
        
        
        let endpoint = "/brands/\(brands_id)"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request", nil)
            return
        }
        
        let parameters: Parameters = [:]
        
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var brand: Brand?
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            brand = Brand.fromJSON(json: json["data"]["brand"])
                        }
                        completion!(result, message!, brand)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", brand)
                    }
                    
                }
            }
        }
    }
    
    public func getBrandFromURL(input_url: String, completion: ((Int, String, Brand?)->())?)    {
        
        auth = AccountService()
        
        
        guard let url = URL(string: input_url) else {
            completion!(-1, "Malformed URL in endpoint request", nil)
            return
        }
        let parameters: Parameters = [:]
        
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(input_url, method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var brand: Brand?
                
                if json["data"]["result"].intValue == 1 || json["data"]["result"].intValue == 0 {
                    result = json["data"]["result"].intValue
                    
                    let message :String? = json["data"]["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            brand = Brand.fromJSON(json: json["data"]["brand"])
                        }
                        completion!(result, message!, brand)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", brand)
                    }
                    
                }
            }
        }
    }
    
}
