//
//  AccessCodeService.swift
//  ObjectVoice
//
//  Created by James Tice on 4/30/21.
//

import Foundation

import Foundation
import SwiftyJSON
import Alamofire
import MobileCoreServices

public class AccessCodeService : ObjectVoiceAPIService   {

    var auth: AccountService

    public override init() {
        auth = AccountService()
        super.init()
    }
    
    public func redeemAccessCode(code: String, completion: ((Int, String)->())?)  {

        let endpoint = "/access_codes/\(code)/redeem"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in endpoint request")
            return
        }

        var parameters: Parameters = [:]
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
        ];

        Alamofire.request(base, method: .post, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {

                let json = JSON(parseJSON: rawTextResponse)
                var result = -1

                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue

                    let message :String? = json["message"].string
                    if(message != nil)  {
                        completion!(result, message!)
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
                    }

                }
            }
        }
    }
    

}

