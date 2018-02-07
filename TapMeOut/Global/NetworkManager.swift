//
//  NetworkManager.swift
//  TapMeOut
//
//  Created by Kristaps Kuzmins on 3/16/17.
//  Copyright © 2017 Kristaps Kuzmins. All rights reserved.
//

import UIKit
import Alamofire

class NetworkManager: NSObject {
    static let sharedClient = NetworkManager()
    var baseURLString: String? = nil
    
    override init() {
        self.baseURLString = KServerURL
        super.init()
    }
    
    func postRequest(tag:String, parameters params:NSDictionary, completion:@escaping (_ error:String, _ response:Any)->Void){
        //let url = KServerURL + tag
        let url =  "\(KServerURL)\(tag)"
        Alamofire.request(url, method:.post, parameters: params as? Parameters).responseJSON { (response) in
            if (response.result.value != nil)
            {
                
                let json = response.result.value as! NSDictionary
                
                
                print (json)
                
                let result = json.value(forKey: "result")
                
                var error:String = ""
                
                if (result != nil)
                {
                   completion(error, result as Any)

                }
                else
                {
                    error = json.value(forKey: "error") as! String
                    completion(error,"")
                 }
                
            }
            else{
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Data: \(utf8Text)")
                }
                let statusCode = response.response?.statusCode
                let error = "HTTP Status:\(statusCode)"
                completion(error, "")
            }
        }
    }
}
