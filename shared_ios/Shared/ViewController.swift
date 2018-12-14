//
//  ViewController.swift
//  Shared
//
//  Created by Denys Meloshyn on 30/11/2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit
import SharedCode
import HTTPNetworking

@objc class HTTPNetworkObjc: NSObject, LoaderI {
    func get(url: String, headers: KotlinMutableDictionary<NSString, NSString>, completion: @escaping (String) -> KotlinUnit) {
    }
    
    func get(url: String, completion: @escaping (String) -> KotlinUnit) {
        let request = URLRequest(url: URL(string: url)!)
        HTTPNetwork.instance.load(request) { (data, response, error) in
            _ = completion(String(data: data!, encoding: String.Encoding.utf8)!)
        }
    }
}

@objc class JsonObjc: NSObject, IJson {
    func serialize(data: String) -> KotlinMutableDictionary<NSString, AnyObject> {
        guard let dataObj = data.data(using: .utf8) else {
            return [:]
        }
        
        do {
            guard let jsonResult = try JSONSerialization.jsonObject(with: dataObj, options: .mutableLeaves) as? [String: AnyObject] else {
                return [:]
            }
            
            return KotlinMutableDictionary(dictionary: jsonResult)
        } catch {
            return [:]
        }
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let g = Git(login: "")
        
        let json = JsonObjc()
        let loader = HTTPNetworkObjc()
//        let m = Manager(loader: loader, json: json)
//        m.loadData { (data) in
//            print("\(data)")
//            return KotlinUnit()
//        }
        print(CommonKt.createApplicationScreenMessage())
        // Do any additional setup after loading the view, typically from a nib.
    }
}

