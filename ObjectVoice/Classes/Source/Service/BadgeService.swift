//
//  BadgeService.swift
//  ObjectVoice
//
//  Created by James Tice on 4/14/21.
//

import Foundation
import SwiftyJSON
import Alamofire
import MobileCoreServices

public class BadgeService : ObjectVoiceAPIService   {

    var auth: AccountService

    public override init() {
        auth = AccountService()
        super.init()
    }
    
    
    public func uploadBadge(code: String, url: String, progress: ((Double)->())?, completion: ((Int, String)->())?)  {
        
        
        let endpoint = "/badges"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        
        guard let endpointUrl = URL(string: base) else {
            completion!(-1, "Malformed URL in API request")
            return
        }
        
        let parameters = [
            "code": code,
        ]
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
        ];
        
        let file = NSURL.init(string: url)
        guard let data = try? Data(contentsOf: file!.absoluteURL!) else {
            completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
            return
        }
        
         Networking.sharedInstance.backgroundSessionManager.upload(
                 multipartFormData: { multipartFormData in
                     for (key, val) in parameters {
                             multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key as! String)
//                        print("\(val) \(val.data(using: String.Encoding.utf8)!) \(key)")
                    }
                    multipartFormData.append(data, withName: "badge", fileName: file!.lastPathComponent!, mimeType:self.mimeTypeForPath(path: url))
//                    print("\(data)")
                 },
                 to: base,
                 method: HTTPMethod.post,
                 headers: headers,
                 encodingCompletion: { encodingResult in
//                    print("\(encodingResult)")
                     switch encodingResult {
                     case .success(let upload, _, _):
                         upload.responseString { response in
                            if let value = response.result.value   {
                                let json = JSON(parseJSON: value)
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
                         upload.uploadProgress { prog in
                            progress!(prog.fractionCompleted)
                        }
                     case .failure(let encodingError):
                         print(encodingError)
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.")
                     }
             }
         )
    }
    
    func mimeTypeForPath(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
}
