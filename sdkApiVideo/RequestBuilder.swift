//
//  RequestBuilder.swift
//  sdkApiVideo
//
//  Created by Romain Petit on 04/02/2021.
//  Copyright © 2021 Romain. All rights reserved.
//

import Foundation

public class RequestBuilder{
    
    public func urLRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = URLRequest(url: URL(string: apiPath)!)
        request.setValue("\(tokenType) \(key)", forHTTPHeaderField: "Authorization")
        request.setValue("api.video SDK (ios; v:0.1.4; )", forHTTPHeaderField: "User-Agent")
        return request
    }
    
    private func setContentType(request: URLRequest){
        var request = request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    public func postClientUrlRequestBuilder(apiPath: String) -> URLRequest{
        var request = URLRequest(url: URL(string: apiPath)!)
        setContentType(request: request)
        request.httpMethod = "POST"
        
        let sHeaderFields = request.allHTTPHeaderFields
        print(sHeaderFields as Any)

        return request
    }
    
    public func postUrlRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = urLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key)
        request.httpMethod = "POST"
        
        let sHeaderFields = request.allHTTPHeaderFields
        print(sHeaderFields as Any)
        return request
    }
    
    public func getUrlRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = urLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key)
        setContentType(request: request)
        request.httpMethod = "GET"
        
        let sHeaderFields = request.allHTTPHeaderFields
        print(sHeaderFields as Any)
        return request
    }
    
    public func deleteUrlRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = urLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key)
        setContentType(request: request)
        request.httpMethod = "DELETE"
        
        let sHeaderFields = request.allHTTPHeaderFields
        print(sHeaderFields as Any)
        return request
    }
    
    public func patchUrlRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = urLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key)
        setContentType(request: request)
        request.httpMethod = "PATCH"
        
        let sHeaderFields = request.allHTTPHeaderFields
        print(sHeaderFields as Any)
        return request
    }
    
    
    public func urlSessionBuilder() -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["User-Agent": "api.video SDK (ios; v:0.1.4; )"]
        let session = URLSession(configuration: sessionConfig)
        
        return session
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
