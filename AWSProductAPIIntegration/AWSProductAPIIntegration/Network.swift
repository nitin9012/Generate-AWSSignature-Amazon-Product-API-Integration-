//
//  Network.swift
//  AWSProductAPIIntegration
//
//  Created by Nitin Bhatt on 3/4/17.
//  Copyright © 2017 Nitin Bhatt. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

class Network{
    func getRequestWithXmlResponse(_ url: String, params: Dictionary<String,AnyObject>, completion: @escaping (_ xmlResponse: XMLIndexer) -> Void){
        let alamoFireManager : Alamofire.SessionManager?
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 // seconds
        configuration.timeoutIntervalForResource = 20
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        
        Alamofire.request(url, method:.get,parameters: params).responseData { response in
            debugPrint("All Response Info: \(response)")
            if let data = response.result.value, let utf8Text = String(data: data, encoding: .utf8) {
                let xml = SWXMLHash.parse(response.result.value!)
                print(xml)
                completion(xml)
            }
        }
    }
    
}

