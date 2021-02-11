//
//  RequestBuilder.swift
//  sdkApiVideo
//
//  Created by Romain Petit on 04/02/2021.
//  Copyright © 2021 Romain. All rights reserved.
//

import Foundation

public class RequestBuilder{
    
    private func genericUrLRequestBuilder(apiPath: String, tokenType: String, key: String, httpMethod: String) -> URLRequest{
        var request = URLRequest(url: URL(string: apiPath)!)
        request.setValue("\(tokenType) \(key)", forHTTPHeaderField: "Authorization")
        request.setValue("api.video SDK (ios; v:0.1.5; )", forHTTPHeaderField: "User-Agent")
        request.httpMethod = httpMethod
        return request
    }
    
    private func setContentType(request: inout URLRequest){
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    private func setMultipartContentType( request: inout URLRequest, boundary: String){
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    }
    
    public func postClientUrlRequestBuilder(apiPath: String) -> URLRequest{
        var request = URLRequest(url: URL(string: apiPath)!)
        setContentType(request: &request)
        request.httpMethod = "POST"
        return request
    }
    
    public func postUrlRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = genericUrLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key, httpMethod: "POST")
        setContentType(request: &request)
        return request
    }
    
    public func postMultipartUrlRequestBuilder(apiPath: String, tokenType: String, key: String, boundary: String) -> URLRequest{
        var request = genericUrLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key, httpMethod: "POST")
        setMultipartContentType(request: &request, boundary: boundary)
        return request
        
    }
    
    public func getUrlRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = genericUrLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key, httpMethod: "GET")
        setContentType(request: &request)
        return request
    }
    
    public func deleteUrlRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = genericUrLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key, httpMethod: "DELETE")
        setContentType(request: &request)
        return request
    }
    
    public func patchUrlRequestBuilder(apiPath: String, tokenType: String, key: String) -> URLRequest{
        var request = genericUrLRequestBuilder(apiPath: apiPath, tokenType: tokenType, key: key, httpMethod: "PATCH")
        setContentType(request: &request)
        return request
    }
    
    
    public func urlSessionBuilder() -> URLSession {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders = ["User-Agent": "api.video SDK (ios; v:0.1.5; )"]
        let session = URLSession(configuration: sessionConfig)
        
        return session
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
