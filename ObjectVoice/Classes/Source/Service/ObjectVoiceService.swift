//
//  ObjectVoiceService.swift
//  ObjectVoice
//
//  Created by James Tice on 6/3/18.
//  Copyright © 2018 ObjectVoice Inc. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import MobileCoreServices

class Networking {
    static let sharedInstance = Networking()
    public var sessionManager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    private init() {
        self.sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.objectvoice.ObjectVoice.backgroundtransfer"))
    }
}

public class ObjectVoiceService : ObjectVoiceAPIService   {
    
    var auth: AccountService
    public static var scan_mode: String = "CONTENT"
    public static var next_scan: String = "CONTENT"
    public static var pending_code: String = ""

    
    public static let SCAN_MODE_TYPE = 0;
    public static let SCAN_MODE_DESCRIPTION = 1;
    
    public static let SCAN_MODE_CONTENT =  "CONTENT";
    public static let SCAN_MODE_MANAGE = "MANAGE";

    public static let SCAN_MODE_CLEAR = "CLEAR";
    public static let SCAN_MODE_CLEAR_RECLAIM = "CLEAR_AND_RECLAIM";
    public static let SCAN_MODE_INFO = "INFO";
    public static let SCAN_MODE_MAP_ADD = "MAP_ADD";
    public static let SCAN_MODE_MAP_REMOVE = "MAP_REMOVE";
    public static let SCAN_MODE_UPGRADE = "UPGRADE";

    public static let DESCRIPTION_CONTENT = "VIEW CONTENT"
    public static let DESCRIPTION_CLEAR = "CLEAR CONTENT"
    public static let DESCRIPTION_INFO = "VIEW INFO"
    public static let DESCRIPTION_MAP_ADD = "ADD TO MAP"
    public static let DESCRIPTION_MAP_REMOVE = "REMOVE FROM MAP"
    public static let DESCRIPTION_UPGRADE = "UPGRADE"
    public static let DESCRIPTION_CLEAR_RECLAIM = "CLEAR AND RECLAIM";

    
    public static let SCAN_TYPE_NFC = "NFC"
    public static let SCAN_TYPE_MAP_TAP = "Map Tap"

    

    
    public static let SCAN_MODES: [[String]] = [
        ["Content", "View Content"],
        ["Clear", "Clear Content"],
        ["Info", "View Info"],
        ["Map", "Add To Map"]
    ]
    
    override init() {
        auth = AccountService()
    }

    
    public func claim(code: String, completion: ((Int, String)->())?)  {
                
        let endpoint = "/object_voices/" + code + "/claim"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in API request")
            return
        }
                
        let parameters: Parameters = [
            "code": code,
        ]
        
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
    
    public func upgrade(code: String, completion: ((Int, String)->())?)  {
        
        let endpoint = "/object_voices/" + code + "/upgrade"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in API request")
            return
        }
        
                
        let parameters: Parameters = [
            "code": code,
        ]
        
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
    
    public func clear(code: String, reclaim: Bool, completion: ((Int, String)->())?)  {

    
        let endpoint = "/object_voices/" + code + "/everything"
        var query_string = "?api_key=" + getAPIKey()
        
        if(reclaim == true) {
            query_string += "&reclaim=true"
        }   else    {
            query_string += "&reclaim=false"
        }
        
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in API request")
            return
        }
                
        let parameters: Parameters = [
            "code": code,
            ]
        
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)",
        ];
        
        
        Alamofire.request(base, method: .delete, parameters: parameters, encoding: JSONEncoding(options: []), headers: headers).response  { response in
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
    
    public func assignURL(code: String, url: String, completion: ((Int, String)->())?)  {
        
        
        let endpoint = "/object_voices/" + code + "/web_locations"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Malformed URL in API request")
            return
        }

        
        let parameters: Parameters = [
            "code": code,
            "type": "text/html",
            "location": url
        ]
        
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
    
    public func assignFile(code: String, url: String, progress: ((Double)->())?, completion: ((Int, String)->())?)  {
        
        
        let endpoint = "/object_voices/" + code + "/web_locations"
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        
        guard let endpointUrl = URL(string: base) else {
            completion!(-1, "Malformed URL in API request")
            return
        }
        
        let parameters = [
            "code": code,
            "type": self.mimeTypeForPath(path: url),
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
                    multipartFormData.append(data, withName: "fileToUpload", fileName: file!.lastPathComponent!, mimeType:self.mimeTypeForPath(path: url))
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
    
    
    public func getObjectVoiceForTag(tag: String, completion: ((Int, String, [ObjectVoice])->())?)    {
        
        if(tag == "")   {
            completion!(-1, "Please enter the tag you would like to search for.", [ObjectVoice]())
            return
        }

        
        let endpoint = "/public/tags/tag_name" + tag
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Unexpected URL format when getting ObjectVoices for tag", [ObjectVoice]())
            return
        }

        
        let parameters: Parameters = [:]
                
        let headers: HTTPHeaders = [
            "authorization": "Bearer \(auth.jwt)"
        ];
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, encoding: JSONEncoding(options: []), headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var object_voice = [ObjectVoice]()
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                            let object_voices = json["data"][ObjectVoice.OBJECT_KEY].array
                            for (key, subJson) in json["data"][ObjectVoice.OBJECT_KEY] {
                                if let code = subJson["code"].string {
                                    if let parsed = ObjectVoice.fromJSON(json: subJson)   {
                                        object_voice.append(parsed)
                                    }
                                }
                            }
                        }
                        completion!(result, message!, object_voice)
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", object_voice)
                    }
                    
                }
            }
        }
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
    
    public func getObjectVoiceForCode(scan_type: String, code: String, tag: OVTag?, completion: ((Int, String, ObjectVoice?)->())?)    {
        
        if(code == "")   {
            completion!(-1, "Please enter the tag you would like to search for.", nil)
            return
        }
        
        let endpoint = "/public/object_voices/" + code
        let query_string = "?api_key=" + getAPIKey()
        let base = getURLString(endpoint: endpoint, query_string: query_string)
        guard let url = URL(string: base) else {
            completion!(-1, "Unexpected URL state getting ObjectVoice for code: " + code, nil)
            return
        }
                
        var parameters: Parameters = [:]
        
        
        let locationService = LocationService()
        let last_location = locationService.getLastLocation()
        
        parameters["scan_type"] = scan_type
        parameters["api_key"] = getAPIKey()
        
        if let lat = last_location?.coordinate.latitude {
            parameters["lat"] = lat
        }
        if let lon = last_location?.coordinate.longitude {
            parameters["lon"] = lon
        }
        if let altitude = last_location?.altitude {
            parameters["altitude"] = altitude
            parameters["provider"] = "ios-gps"
        }
        if let timestamp = last_location?.timestamp {
            parameters["location_acquired"] = timestamp.timeIntervalSince1970
        }
        if let horizontal_accuracy = last_location?.horizontalAccuracy {
            parameters["accuracy"] = horizontal_accuracy
        }
        if let timestamp = last_location?.timestamp {
            parameters["location_acquired"] = "\(timestamp.timeIntervalSince1970)"
        }
        if let t_id = tag?.tags_id {
            parameters["tags_id"] = t_id
        }
                
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(auth.jwt)",
            //  "Accept": "application/json"
        ];
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(base, method: .get, parameters: parameters, headers: headers).response  { response in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let data = response.data, let rawTextResponse = String(data: data, encoding: .utf8) {
                let json = JSON(parseJSON: rawTextResponse)
                var result = -1
                var object_voice: ObjectVoice?
                
                if json["result"].intValue == 1 || json["result"].intValue == 0 {
                    result = json["result"].intValue
                    
                    let message :String? = json["message"].string
                    if(message != nil)  {
                        if(result == 1) {
                             object_voice = ObjectVoice.fromJSON(json: json["data"][ObjectVoice.OBJECT_KEY])
                        }
                        completion!(result, message!, object_voice)
                        
                    }   else    {
                        completion!(-1, "Invalid response from server, please try again or contact james@objectvoice.com for assistance.", object_voice)
                    }
                    
                }
            }
        }
    }
    
    public static let KEY_LAST_SCANNED = "ov_last_scanned"
    public static let KEY_SCAN_MODE = "ov_scan_mode"
    public static let KEY_SCAN_PREFIX = "ov_scan_"
    
    public func setLastCodeScanned(code: String)  {
        let defaults = UserDefaults.standard
        defaults.set(code, forKey: ObjectVoiceService.KEY_LAST_SCANNED)
        defaults.set(Int(Date().timeIntervalSince1970), forKey: ObjectVoiceService.KEY_LAST_SCANNED + code)
    }
    
    public func getLastCodeScanned() -> String   {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: ObjectVoiceService.KEY_LAST_SCANNED) as? String ?? String()
    }
    
    public func setScanMode(mode: String)  {
        let defaults = UserDefaults.standard
        defaults.set(mode, forKey: ObjectVoiceService.KEY_SCAN_MODE)
    }
    
    public func getScanMode() -> String   {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: ObjectVoiceService.KEY_SCAN_MODE) as? String ?? ObjectVoiceService.SCAN_MODE_CONTENT
    }
    
    public func getLastScan(code: String) -> Int   {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: ObjectVoiceService.KEY_SCAN_PREFIX + code)
    }
    
    public func clearScanCache()   {
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
            if(key.starts(with: ObjectVoiceService.KEY_SCAN_PREFIX))    {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
        UserDefaults.standard.synchronize()
    }
    
}
