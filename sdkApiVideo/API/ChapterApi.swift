//
//  ChapterApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 28/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation
import MobileCoreServices


public class ChapterApi{
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
    
    /**
     - Parameters:
        - videoId: The videoId to upload chapter
        - url: The URL of .vtt file
        - filePath: The .vtt file path
        - fileName: The .vtt file name (for example: chapter_en.vtt)
        - language: The language for the .vtt file (for exemple: en)
     */
    public func uploadChapter(videoId: String, url: URL, filePath: String, fileName: String, language: String, completion: @escaping(Bool, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.chapters.rawValue + "/" + language
        let boundary = generateBoundaryString()
        var request = RequestBuilder().postUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? createBodyWithUrl(url: url, filePath: filePath, fileName: fileName, boundary: boundary)
        
        var isUploaded = false
        var resp: Response?
        
        let session = RequestBuilder().urlSessionBuilder()
        TaskExecutor().execute(session: session, request: request){ (data, response) in
            if(data != nil){
                isUploaded = true
                completion(isUploaded, resp)
            }else{
                resp = response
                completion(isUploaded, resp)
            }
        }
    }
    
    /**
    - Parameters:
       - videoId: The videoId to get chapter of the video
       - language: The language of the .vtt file (for exemple: en)
    */
    public func getChapter(videoId: String, language: String, completion: @escaping(Chapter?, Response?)->()){
        var chapter: Chapter?
        var resp: Response?
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.chapters.rawValue + "/\(language)"
        let request = RequestBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestBuilder().urlSessionBuilder()
        TaskExecutor().execute(session: session, request: request, group: group){(data, response) in
            if(data != nil){
                chapter = try? self.decoder.decode(Chapter.self, from: data!)
                completion(chapter, resp)
            }else{
                resp = response
                completion(chapter, resp)
            }
        }
        group.wait()
    }
    
    /**
    - Parameters:
       - videoId: The videoId to get all chapters of the video
    */
    public func getAllChapters(videoId: String, completion: @escaping([Chapter], Response?) -> ()){
        var chapters: [Chapter] = []
        let path = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.chapters.rawValue
        var nbItems = self.pagination.getNbOfItems(apiPath: path)
        var resp: Response?
        
        if(nbItems > 0){
            nbItems = nbItems - 1
        }
        for number in (0...nbItems){
            let apiPath = "\(path)?currentPage=\(number + 1)&pageSize=25"
            let request = RequestBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
            
            let group = DispatchGroup()
            group.enter()
            
            let session = RequestBuilder().urlSessionBuilder()
            TaskExecutor().execute(session: session, request: request, group: group){(data, response) in
                if(data != nil){
                    let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                    for d in json!["data"] as! [AnyObject]{
                        let jsonData = try? JSONSerialization.data(withJSONObject:d)
                        let chapter = try? self.decoder.decode(Chapter.self, from: jsonData!)
                        chapters.append(chapter!)
                    }
                }else{
                    resp = response
                }
            }
            group.wait()
        }
        completion(chapters,resp)
    }
    
    /**
     - Parameters:
        - videoId: The videoId to get all chapters of the video
        - language: The language to delete the good file (for exemple: en)
     */
    public func deleteChapter(videoId: String, language: String, completion: @escaping(Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.chapters.rawValue + "/\(language)"
        let request = RequestBuilder().deleteUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        var deleted = false
        var resp : Response?
       
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestBuilder().urlSessionBuilder()
        TaskExecutor().execute(session: session, request: request, group: group){(data, response) in
            if(data != nil){
                deleted = true
                completion(deleted, resp)
            }else{
                resp = response
                completion(deleted, resp)
            }
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
