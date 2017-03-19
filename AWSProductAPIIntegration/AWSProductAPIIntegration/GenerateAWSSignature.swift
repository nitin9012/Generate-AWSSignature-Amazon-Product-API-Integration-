//
//  GenerateAWSSignature.swift
//  AWSProductAPIIntegration
//
//  Created by Nitin Bhatt on 3/4/17.
//  Copyright © 2017 Nitin Bhatt. All rights reserved.
//


import Foundation
import AWSCore
import Alamofire

class AWSSignature {
    
    func signedParametersForParameters(_ parameters: [String: String]) -> [String:AnyObject]{
        let secretKey = getAmazonAccountCredentials().2
        let sortedKeys = Array(parameters.keys).sorted(by: <)
        var components: [(String, String)] = []
        
        for  key in sortedKeys {
            components += URLEncoding.queryString.queryComponents(fromKey: key, value: parameters[key]!)
        }
        
        let query = (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
        let stringToSign = "GET\nwebservices.amazon.in\n/onca/xml\n\(query)"
        let dataToSign = stringToSign.data(using: String.Encoding.utf8)
        
        let signature = AWSSignatureSignerUtility.hmacSign(dataToSign, withKey: secretKey, usingAlgorithm: UInt32(kCCHmacAlgSHA256))!
        
        var params : [String:AnyObject] = parameters as [String : AnyObject]
        
        params["Signature"] = signature as AnyObject?
        
        
        
        return params
        
    }
    
    
    func itemSearchUsingBrowseId(_ page:String,browseNodeId:String,serachIndex:String,sorting:String,maximumPrice:String,minimumPrice:String) -> [String:AnyObject]{
        let accessKey = getAmazonAccountCredentials().0
        let associateTag = getAmazonAccountCredentials().1
        let timestamp = getTimestamp()
        var keyParams = ["Service": "AWSECommerceService", "Operation": "ItemSearch","BrowseNode": browseNodeId,"ItemPage": page,"Timestamp": timestamp.string(from: Date()),"AWSAccessKeyId": accessKey, "AssociateTag": associateTag,"ResponseGroup":"OfferSummary,Images,Medium,VariationSummary","SearchIndex":serachIndex,"Availability":"Available","Sort": sorting]
        
        if (maximumPrice.isEmpty == false) && (minimumPrice.isEmpty == false){
            keyParams["MaximumPrice"] = "\(maximumPrice)00"
            keyParams["MinimumPrice"] = "\(minimumPrice)00"
        }
        print("response parmas")
        print(keyParams)
        
        let globalSearchParams = signedParametersForParameters(keyParams)
        return globalSearchParams
    }
    
    
    func itemSearch(_ page:String,searchKeyword:String,searchIndex:String,maximumPrice:String,minimumPrice:String,sorting:String) -> [String:AnyObject]{
        let accessKey = getAmazonAccountCredentials().0
        let associateTag = getAmazonAccountCredentials().1
        let timestamp = getTimestamp()
        var keyParams = ["Service": "AWSECommerceService", "Operation": "ItemSearch","Keywords": searchKeyword,"ItemPage": page,"Timestamp": timestamp.string(from: Date()),"AWSAccessKeyId": accessKey, "AssociateTag": associateTag,"ResponseGroup":"OfferSummary,Images,Medium,VariationSummary","SearchIndex":searchIndex,"Availability":"Available"]
        
        if (searchIndex.lowercased() != "all"){
            keyParams["Sort"] = sorting
        }
        
        if (maximumPrice.isEmpty == false) && (minimumPrice.isEmpty == false){
            keyParams["MaximumPrice"] = "\(maximumPrice)00"
            keyParams["MinimumPrice"] = "\(minimumPrice)00"
        }
        
        print("response parmas")
        print(keyParams)
        
        let globalSearchParams = signedParametersForParameters(keyParams)
        return globalSearchParams
    }
    
    func browseNodeLookUp(_ browseNodeId:String)-> [String:AnyObject]{
        let accessKey = getAmazonAccountCredentials().0
        let associateTag = getAmazonAccountCredentials().1
        let timestamp = getTimestamp()
        let keyParams = ["Service": "AWSECommerceService", "Operation": "BrowseNodeLookup", "BrowseNodeId": browseNodeId, "ResponseGroup": "BrowseNodeInfo","AWSAccessKeyId": accessKey, "AssociateTag": associateTag, "Timestamp": timestamp.string(from: Date())]
        let globalSearchParams = signedParametersForParameters(keyParams)
        return globalSearchParams
    }
    
    
    func itemLookUp(_ asin:String) -> [String:AnyObject]{
        let accessKey = getAmazonAccountCredentials().0
        let associateTag = getAmazonAccountCredentials().1
        let timestamp = getTimestamp()
        let keyParams = ["Service": "AWSECommerceService", "Operation": "ItemLookup","ItemId": asin ,"Timestamp": timestamp.string(from: Date()),"AWSAccessKeyId": accessKey, "AssociateTag": associateTag,"ResponseGroup":"Offers,Images,Medium,VariationSummary,VariationMatrix","idType": "ASIN"]
        
        
        print("response parmas")
        print(keyParams)
        
        let globalSearchParams = signedParametersForParameters(keyParams)
        return globalSearchParams
    }
    
    
    
    func getAmazonAccountCredentials()->(String,String,String){
        let AWSAccessKey = "-----"
        let AssociateTag = "-----"
        let AWSSecretKey = "----"
        
        return (AWSAccessKey,AssociateTag,AWSSecretKey)
        
    }
    
    func getTimestamp() -> DateFormatter{
        var timestampFormatter = DateFormatter()
        timestampFormatter = DateFormatter()
        timestampFormatter.dateFormat = AWSDateISO8601DateFormat3
        timestampFormatter.timeZone = TimeZone(identifier: "GMT")
        timestampFormatter.locale = Locale(identifier: "en_US_POSIX")
        return timestampFormatter
    }
}



