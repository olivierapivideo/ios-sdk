//
//  TaskExecutor.swift
//  sdkApiVideo
//
//  Created by Romain Petit on 24/12/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public class TaskExecutor{
    private let decoder = JSONDecoder()

    public func execute(session: URLSession, request: URLRequest, group: DispatchGroup?, completion: @escaping (Data?, Response?) -> ()){
        var resp: Response? = nil
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse!.statusCode{
            case 200 ... 299:
                completion(data, resp)
                
            case 400, 401, 404:
                if(json != nil){
                    let data: Data? = nil
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as? String, statusCode: stringStatus, message: json!["title"] as? String)
                    completion(data,resp)
                }
            default:
                if(json != nil){
                    let data: Data?  = nil
                    let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                    resp = Response(url: json!["type"] as? String, statusCode: stringStatus, message: json!["title"] as? String)
                    completion(data,resp)
                }
            }
            if(group != nil){
                group!.leave()
            }
        })
        task.resume()
    }
    
    public func execute(session: URLSession, request: URLRequest, completion: @escaping (Data?, Response?) -> ()){
        execute(session: session, request: request, group: nil){(data, response) in
            completion(data, response)
        }
    }
}
