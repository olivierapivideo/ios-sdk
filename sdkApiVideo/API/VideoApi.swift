//
//  VideoApi.swift
//  sdkApiVideo
//
//  Created by Romain on 14/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//
import Foundation
import MobileCoreServices
import VideoUploaderIos

public class VideoApi{
    enum NetworkError: Error {
        case url
        case server
    }
    
    private var chunkSize: Int = ((1024 * 1024) * 30) // MB
    
    private var tokenType: String!
    private var key: String!
    private var environnement: String!
    private let pagination : Pagination!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var sumChunk = 0
    
    public init(tokenType: String, key: String, environnement: String){
        self.tokenType = tokenType
        self.key = key
        self.environnement = environnement
        self.pagination = Pagination(tokenType: tokenType, key: key)
    }
    
    public func setChunkSize(size: Int) {
        self.chunkSize = size
    }
    
    public func getChunkSize() -> Int {
        return self.chunkSize
    }
    
    
    //MARK: Init video
    public func initVideo(title: String, description: String, completion: @escaping (Video?, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue
        let body = ["title": title, "description": description] as Dictionary<String, String>
        
        var request = RequestsBuilder().postUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request){ (data, response) in
            completion(data != nil ? try? self.decoder.decode(Video.self, from: data!) : nil, response)
        }
    }
    
    
    //MARK: Init and Upload video
    public func create(title: String, description: String, fileName: String, filePath: String, url: URL, completion: @escaping (Video?, Response?) -> ()){
        initVideo(title: title, description: description){ (v, resp) in
            //if Error
            if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                //return videoCreated = false
                //return descripted response
                completion(nil, resp)
            }
            // if video is created
            else {
                // if no error with the video uri
                if(v != nil) {
                    let uploader = VideoUploader()
                    uploader.uploadWithAuthentication(bearerToken: self.key, videoId: (v?.videoId!)!, fileName: fileName, filePath: filePath, url: url) { json, apiError in
                        if(apiError != nil) {
                            completion(nil, Response(url: apiError?.url, statusCode: apiError?.statusCode, message: apiError?.message))
                        } else {
                            completion(v, nil)
                        }
                    }
                }
                // if error with the uri
                else{
                    completion(nil, resp)
                }
            }
        }
    }
    
    
    
    private func createBodyWithData(data: Data, filePath: String, fileName: String, boundary: String) throws -> Data{
        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePath)\"; filename=\"\(fileName)\"\r\n")
        body.append("Content-Type: \r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        return body
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
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
    
    
    //MARK: Get video by id
    public func getVideoByID(videoId: String, completion: @escaping (Video?, Response?) -> ()){
        var video: Video?
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/" + videoId
        let request = RequestsBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){ (data, response) in
            if(data != nil){
//                let jsonData = try? JSONSerialization.data(withJSONObject:data)
                video = try? self.decoder.decode(Video.self, from: data!)
            }
            completion(video, response)
        }
        group.wait()
    }
    
    //MARK: Get all videos
    public func getAllVideos(completion: @escaping ([Video], Response?) -> ()){
        var videos: [Video] = []
        let path = self.environnement + ApiPaths.videos.rawValue
        var nbItems = 0
        self.pagination.getNbOfItems(apiPath: path){(nb, response)in
            if(response == nil){
                nbItems = nb
            }
        }
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
            
            TasksExecutor().execute(session: session, request: request, group: group){ (data, response) in
                if(data != nil){
                    let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                    for data in json!["data"] as! [AnyObject]{
                        let jsonData = try? JSONSerialization.data(withJSONObject:data)
                        let video = try? self.decoder.decode(Video.self, from: jsonData!)
                        videos.append(video!)
                    }
                }else{
                    resp = response
                    completion(videos, resp)
                }
            }
            group.wait()
        }
        completion(videos, resp)
    }
    
    //MARK: Delete video
    public func deleteVideo(videoId: String, completion: @escaping (Bool, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)"
        
        let request = RequestsBuilder().deleteUrlRequestBuilder(apiPath: apiPath,tokenType: self.tokenType, key: self.key)
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        
        TasksExecutor().execute(session: session, request: request, group: group){(data, response) in
            completion(data != nil, response)
        }
        group.wait()
    }
    
    //MARK: Update video
    public func updateVideo(video: Video, completion: @escaping (Bool, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(String(describing: video.videoId!))"
        let body = [
            "title": video.title!,
            "description": video.description!,
            "public": video.isPublic!,
            "panoramic": video.isPanoramic!
        ] as Dictionary<String, AnyObject>
        
        var request = RequestsBuilder().patchUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){ (data, response) in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            if(json != nil){
                completion(data != nil, response)
            }
        }
        group.wait()
        
    }
    
    //MARK: Get video status
    public func getStatus(videoId: String, completion: @escaping (Status?, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/" + videoId + ApiPaths.status.rawValue
        
        var status: Status?
        
        let request = RequestsBuilder().getUrlRequestBuilder(apiPath: apiPath,tokenType: self.tokenType, key: self.key)
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request){ (data, response) in
            if(data != nil){
                status = try? self.decoder.decode(Status.self, from: data!)
            }
            completion(status, response)
        }
    }
    
    //MARK: Pick Thumbnail
    public func pickThumbnail(videoId: String, timecode: String, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.thumbnail.rawValue
        
        let body = [
            "timecode": timecode,
        ] as Dictionary<String, String>
        
        var request = RequestsBuilder().patchUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        let session = RequestsBuilder().urlSessionBuilder()
        
        TasksExecutor().execute(session: session, request: request){ (data, response) in
            completion(data != nil, response)
        }
    }
    
    
    //MARK: Uplaod an image as Thumbnail
    public func uploadImageThumbnail(videoId: String, url: URL, filePath: String, fileName: String, imageData: Data, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.thumbnail.rawValue
        
        let boundary = generateBoundaryString()
        
        var request = RequestsBuilder().postMultipartUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key, boundary: boundary)
        request.httpBody = try? createBodyWithData(data: imageData, filePath: filePath, fileName: fileName, boundary: boundary)
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request){ (data, response) in
            completion(data != nil, response)
        }
    }
}
extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}

extension Stream {
    func boundPair(bufferSize: Int) -> (inputStream: InputStream, outputStream: OutputStream) {
        var inStream: InputStream? = nil
        var outStream: OutputStream? = nil
        Stream.getBoundStreams(withBufferSize: bufferSize, inputStream: &inStream, outputStream: &outStream)
        return (inStream!, outStream!)
    }
}
