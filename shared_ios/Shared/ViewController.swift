//
//  ViewController.swift
//  Shared
//
//  Created by Denys Meloshyn on 30/11/2018.
//  Copyright © 2018 Denys Meloshyn. All rights reserved.
//

import UIKit
import SharedCode

public typealias HTTPCompletionBlock = (Data?, HTTPURLResponse?, Error?) -> Void
public typealias HTTPJSONCompletionBlock = (Any?, HTTPURLResponse?, Error?) -> Void

public enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

public extension URLRequest {
    var method: HTTPMethod? {
        set {
            httpMethod = newValue?.rawValue
        }
        get {
            return HTTPMethod(rawValue: httpMethod ?? "")
        }
    }
}

public extension URLComponents {
    static func httpsComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        
        return components
    }
}

public protocol HTTPProtocol {
    @discardableResult func load(_ request: URLRequest, completion: HTTPCompletionBlock?) -> URLSessionDataTask
    @discardableResult func load(_ request: URLRequest, executeCompletionBlockInMainThread: Bool, completion: HTTPCompletionBlock?) -> URLSessionDataTask
    
    @discardableResult func loadJSON(_ request: URLRequest, completion: HTTPJSONCompletionBlock?) -> URLSessionDataTask
    @discardableResult func loadJSON(_ request: URLRequest, executeCompletionBlockInMainThread: Bool, completion: HTTPJSONCompletionBlock?) -> URLSessionDataTask
}

@objc class HTTPNetwork2: NSObject, HTTPProtocol {
    public static let instance = HTTPNetwork2()
    
    private let session: URLSession
    
    public init(session: URLSession = URLSession(configuration: URLSessionConfiguration.default)) {
        self.session = session
    }
    
    @discardableResult public func load(_ request: URLRequest, completion: HTTPCompletionBlock?) -> URLSessionDataTask {
        return load(request, executeCompletionBlockInMainThread: true, completion: completion)
    }
    
    @discardableResult public func load(_ request: URLRequest, executeCompletionBlockInMainThread: Bool, completion: HTTPCompletionBlock?) -> URLSessionDataTask {
        let completionResponseBlock = { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if executeCompletionBlockInMainThread {
                DispatchQueue.main.async {
                    completion?(data, response as? HTTPURLResponse, error)
                }
            } else {
                completion?(data, response as? HTTPURLResponse, error)
            }
        }
        
        let task = session.dataTask(with: request, completionHandler: completionResponseBlock)
        task.resume()
        
        return task
    }
    
    @discardableResult public func loadJSON(_ request: URLRequest, completion: HTTPJSONCompletionBlock?) -> URLSessionDataTask {
        return loadJSON(request, executeCompletionBlockInMainThread: true, completion: completion)
    }
    
    @discardableResult public func loadJSON(_ request: URLRequest, executeCompletionBlockInMainThread: Bool, completion: HTTPJSONCompletionBlock?) -> URLSessionDataTask {
        return load(request, executeCompletionBlockInMainThread: executeCompletionBlockInMainThread) { data, response, error in
            if error != nil {
                if executeCompletionBlockInMainThread {
                    DispatchQueue.main.async {
                        completion?(data, response, error)
                    }
                } else {
                    completion?(data, response, error)
                }
                return
            }
            
            guard let data = data else {
                if executeCompletionBlockInMainThread {
                    DispatchQueue.main.async {
                        completion?(nil, response, error)
                    }
                } else {
                    completion?(nil, response, error)
                }
                return
            }
            
            do {
                let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                if executeCompletionBlockInMainThread {
                    DispatchQueue.main.async {
                        completion?(result, response, error)
                    }
                } else {
                    completion?(result, response, error)
                }
            } catch {
                if executeCompletionBlockInMainThread {
                    DispatchQueue.main.async {
                        completion?(data, response, error)
                    }
                } else {
                    completion?(data, response, error)
                }
            }
        }
    }
}


extension HTTPNetwork2: LoaderI {
    public func get(url: String, completion: @escaping (String) -> KotlinUnit) {
        let request = URLRequest(url: URL(string: url)!)
        load(request) { (data, response, error) in
            _ = completion(String(data: data!, encoding: String.Encoding.utf8)!)
        }
    }
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let m = Manager(loader: HTTPNetwork2.instance)
        m.loadData { (data) in
            print("\(data)")
            return KotlinUnit()
        }
        print(CommonKt.createApplicationScreenMessage())
        // Do any additional setup after loading the view, typically from a nib.
    }


}

