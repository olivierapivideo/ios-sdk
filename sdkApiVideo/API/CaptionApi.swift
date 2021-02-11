//
//  CaptionApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 27/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation
import MobileCoreServices


public class CaptionApi{
    private var tokenType: String!
    private var key: String!
    private var environnement: String!
    private let pagination : Pagination!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init(tokenType: String, key: String, environnement: String){
        self.tokenType = tokenType
        self.key = key
        self.environnement = environnement
        self.pagination = Pagination(tokenType: tokenType, key: key)
    }
    
    public func upload(videoId: String, url: URL, filePath: String, fileName: String, language: String, completion: @escaping(Bool, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.captions.rawValue + "/" + language
        let boundary = generateBoundaryString()
        var request = RequestsBuilder().postMultipartUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key,boundary: boundary)
        
        request.httpBody = try? createBodyWithUrl(url: url, filePath: filePath, fileName: fileName, boundary: boundary)
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request){(data, response) in
            completion(data != nil, response)
        }
    }
    
    public func getCaption(videoId: String, language: String, completion: @escaping(Caption?, Response?)->()){
        var caption: Caption?
        var resp: Response?
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.captions.rawValue + "/\(language)"
        let request = RequestsBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){(data, response) in
            if(data != nil){
                caption = try? self.decoder.decode(Caption.self, from: data!)
                completion(caption, resp)
            }else{
                resp = response
                completion(caption, resp)
            }
        }
        group.wait()
    }
    
    public func getAllCaptions(videoId: String, completion: @escaping([Caption], Response?) -> ()){
        var captions: [Caption] = []
        let path = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.captions.rawValue
        var nbItems = self.pagination.getNbOfItems(apiPath: path)
        var resp: Response?
        
        if(nbItems > 0){
            nbItems = nbItems - 1
        }
        for number in (0...nbItems){
            let apiPath = "\(path)?currentPage=\(number + 1)&pageSize=25"
            let request = RequestsBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
            
            let group = DispatchGroup()
            group.enter()
            
            let session = RequestsBuilder().urlSessionBuilder()
            TasksExecutor().execute(session: session, request: request, group: group){(data, response) in
                if(data != nil){
                    let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                    for d in json!["data"] as! [AnyObject]{
                        let jsonData = try? JSONSerialization.data(withJSONObject:d)
                        let caption = try? self.decoder.decode(Caption.self, from: jsonData!)
                        captions.append(caption!)
                    }
                }else{
                    resp = response
                }
            }
            group.wait()
        }
        completion(captions,resp)
    }
    
    public func updateDefaultValue(videoId: String, language: String, isDefault: Bool, completion: @escaping(Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.captions.rawValue + "/\(language)"
        let body = [
        "default": isDefault,
        ] as Dictionary<String, AnyObject>
        var request = RequestsBuilder().patchUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){(data, response) in
            completion(data != nil, response)
        }
        group.wait()
    }
    
    public func deleteCaption(videoId: String, language: String, completion: @escaping(Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.captions.rawValue + "/\(language)"
        let request = RequestsBuilder().deleteUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){(data, response) in
            completion(data != nil, response)
        }
        group.wait()
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    private func createBodyWithUrl(url: URL, filePath: String, fileName: String, boundary: String) throws -> Data{
        var body = Data()
        let data = try Data(contentsOf: url)
        let mimetype = mimeType(for: filePath)
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePath)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    private func mimeType(for path: String) -> String {
        let url = URL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
}
