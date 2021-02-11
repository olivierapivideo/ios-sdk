//
//  Pagination.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 27/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public class Pagination{
    private var tokenType: String!
    private var key: String!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(tokenType: String, key: String){
        self.tokenType = tokenType
        self.key = key
    }
    
    public func getNbOfItems(apiPath: String)-> Int{
        var resp: Response?
        var nbOfItems = 0
        let request = RequestBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestBuilder().urlSessionBuilder()
        TaskExecutor().execute(session: session, request: request, group: group){(data, response) in
            if(data != nil){
                let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                let pagination = json!["pagination"] as! Dictionary<String, AnyObject>
                let itemsTotal = pagination["pagesTotal"]
                nbOfItems = itemsTotal as! Int
            }else{
                resp = response
            }
        }
        group.wait()
        return nbOfItems
    }
}
