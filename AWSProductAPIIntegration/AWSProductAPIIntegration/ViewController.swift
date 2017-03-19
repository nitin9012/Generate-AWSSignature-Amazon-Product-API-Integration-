//
//  ViewController.swift
//  AWSProductAPIIntegration
//
//  Created by Nitin Bhatt on 3/4/17.
//  Copyright © 2017 Nitin Bhatt. All rights reserved.
//

import UIKit
import Alamofire
import SWXMLHash

class ViewController: UIViewController {

    var awsProductApi = "http://webservices.amazon.in/onca/xml"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getAWSSignature()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getAWSSignature(){
        let parameters =   AWSSignature().browseNodeLookUp("1571272031")
        print("AWSParameters",parameters)
    }
}

