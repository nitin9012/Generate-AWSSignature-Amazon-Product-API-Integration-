# Generate-AWSSignature-Amazon-Product-API-Integration-

In this example , I have implemented how to integration amazon product api on iOS using swift 3.0

What is Amazon Product API ?

Amazon provided the API through which we can access the products data like (Product name, image,prices) from amazon database and diplay this in our app.

For more info please go through this link

http://docs.aws.amazon.com/AWSECommerceService/latest/DG/Welcome.html

To use AWS product API in iOS app create an AWS account using this link https://portal.aws.amazon.com/billing/signup?redirect_url=https%3A%2F%2Faws.amazon.com%2Fregistration-confirmation


In this example i have implemeted how to genrate AWS signature for amazon product API.


First write this code inside your podfile
```
platform :ios, '9.0'
use_frameworks!
source 'https://github.com/CocoaPods/Specs.git'

target 'AWSProductAPIIntegration' do
     pod 'Alamofire'
     pod 'AWSCore'
     pod ‘SWXMLHash’
end
```
After that get AWSAccessKey, AssociateTag, AWSSecretKey from your AWS account and add your credential inside this function

    func getAmazonAccountCredentials()->(String,String,String){
        let AWSAccessKey = "-----"
        let AssociateTag = "-----"
        let AWSSecretKey = "----"
        
        return (AWSAccessKey,AssociateTag,AWSSecretKey)
        
    }
    
   If you see this code your can see i am using "ResponseGroup":"OfferSummary,Images,Medium,VariationSummary" you can change reponse group according to your requirement.
   
   for more information about response group plese refer to this link
   http://docs.aws.amazon.com/AWSECommerceService/latest/DG/CHAP_ResponseGroupsList.html
   
Here i am using itemSeach operation there are many operation available it AWS product API change it according to your own requirement.

For more infromation please refer to this link:- 
   http://docs.aws.amazon.com/AWSECommerceService/latest/DG/CHAP_OperationListAlphabetical.html
  
  
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
    
  
    
    
   

