//
//  VideoApi.swift
//  sdkApiVideo
//
//  Created by Romain on 14/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//
import Foundation
import MobileCoreServices

public class VideoApi{
    enum NetworkError: Error {
        case url
        case server
    }
    
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
    
    //MARK: Init video
    public func initVideo(title: String, description: String, completion: @escaping (String, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue
        let body = ["title": title, "description": description] as Dictionary<String, String>
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        var resp: Response?
        var uri = ""
        
        let session = URLSession.shared
        TaskExecutor().execute(session: session, request: request){ (data, response) in
            if(data != nil){
                let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>

                let source = json?["source"] as! Dictionary<String, AnyObject>
                uri = source["uri"] as! String
                completion(uri, resp)
            }else{
                resp = response
                completion(uri, resp)
            }
        }
    }
    
    
    //MARK: Init and Upload video
    public func create(title: String, description: String, fileName: String, filePath: String, url: URL, completion: @escaping (Bool, Response?) -> ()){
        initVideo(title: title, description: description){ (uri, resp) in
            var videoCreated = false
            //if Error
            if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                //return videoCreated = false
                //return descripted response
                completion(videoCreated, resp)
            }
            // if video is created
            else{
                // if no error with the video uri
                if(uri != "") {
                    // get data lenght to upload a big or a small file
                    let data = try? Data(contentsOf: url)
                    let dataLen = data!.count
                    // if data lenght < 30mb upload small file else upload big file
                    if(dataLen < ((1024 * 1000) * 30)){
                        self.uploadSmallVideoFile(videoUri: uri, fileName: fileName, filePath: filePath, url: url){ (crea, resp) in
                            // if video is uploaded
                            if(crea){
                                videoCreated = crea
                                completion(videoCreated, resp)
                            }
                            // if video upload return error
                            else{
                                completion(videoCreated, resp)
                            }
                        }
                    }else{
                        self.uploadBigVideoFile(videoUri: uri, fileName: fileName, filePath: filePath, url: url){ (crea, resp) in
                            // if video is uploaded
                            if(crea){
                                videoCreated = crea
                                completion(videoCreated, resp)
                            }
                            // if video upload return error
                            else{
                                completion(videoCreated, resp)
                            }
                        }
                    }
                }
                // if error with the uri
                else{
                    completion(videoCreated, resp)
                }
            }
        }
    }
    
    
    
    
    
    //MARK: Upload small video
    public func uploadSmallVideoFile(videoUri: String, fileName: String, filePath: String, url: URL, completion: @escaping (Bool, Response?) -> ()){
        let apiPath = self.environnement + videoUri
        var request = URLRequest(url: URL(string: apiPath)!)
        let boundary = generateBoundaryString()
        
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? createBodyWithUrl(url: url, filePath: filePath, fileName: fileName, boundary: boundary)
        
        var resp: Response?
        var uploaded = false
        
        let session = URLSession.shared
        TaskExecutor().execute(session: session, request: request){(data, response) in
            if(data != nil){
                uploaded = true
                completion(uploaded, resp)
            }else{
                resp = response
                completion(uploaded, resp)
            }
        }
    }
    
    public func createStream(title: String, description: String, fileName: String, filePath: String, url: URL, completion: @escaping (Bool, Response?) -> ()){
        initVideo(title: title, description: description){ (uri, resp) in
            var videoCreated = false
            //if Error
            if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                //return videoCreated = false
                //return descripted response
                completion(videoCreated, resp)
            }
            // if video is created
            else{
                // if no error with the video uri
                if(uri != "") {
                    // get data lenght to upload a big or a small file
                    let data = try? Data(contentsOf: url)
                    let dataLen = data!.count
                    // if data lenght < 30mb upload small file else upload big file
                    if(dataLen < ((1024 * 1000) * 30)){
                        print("choose a largest video")
                    }else{
                        self.uploadLargeStream(videoUri: uri, fileName: fileName, filePath: filePath, url: url){ (crea, resp) in
                            // if video is uploaded
                            if(crea){
                                videoCreated = crea
                                completion(videoCreated, resp)
                            }
                            // if video upload return error
                            else{
                                completion(videoCreated, resp)
                            }
                        }
                    }
                }
                // if error with the uri
                else{
                    completion(videoCreated, resp)
                }
            }
        }
    }
    
    //MARK: Upload Large video by stream (WIP)
    public func uploadLargeStream(videoUri: String, fileName: String, filePath: String, url: URL, completion: @escaping (Bool, Response?) -> ()){
        let chunkSize: Int = ((1024 * 1024) * 30) // MB
        let apiPath = self.environnement + videoUri
        var request = URLRequest(url: URL(string: apiPath)!)
        let boundary = generateBoundaryString()
        let data = try? Data(contentsOf: url)
        let fileLength = data!.count
        let stream = InputStream.init(url: url)
        var bytesRead = 0
        
        
        
        print("fileLength \(fileLength)")
        print("chunkSize \(chunkSize)")
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: chunkSize)
        for offset in stride(from: 0, through: fileLength, by: chunkSize){
            let input = InputStream.init(url: url)
            var currentPosition = offset + chunkSize - 1
            var read: Int
            var output: OutputStream? = OutputStream()
            
            
            if(currentPosition > fileLength){
                currentPosition = fileLength - 1
            }else{
                read = (input?.read(buffer, maxLength: chunkSize))!
                output!.write(buffer, maxLength: read)
                
                var inStream: InputStream? = nil
                var outStream: OutputStream? = nil
                Stream.getBoundStreams(withBufferSize: chunkSize, inputStream: &inStream, outputStream: &outStream)
                
                
            }
            
            //output.write(buffer, maxLength: read)
            
            request.httpMethod = "POST"
            request.setValue("bytes \(offset)-\(currentPosition)/\(fileLength)", forHTTPHeaderField: "Content-Range")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
//            request.httpBodyStream()
            
//            let config = URLSessionConfiguration.default
//            request.httpBody = try? createBodyWithData(data: data, filePath: filePath, fileName: fileName, boundary: boundary)
            let session = URLSession.shared
            let task = session.uploadTask(withStreamedRequest: request as URLRequest)
            task.resume()
            print("offset : \(offset)")
            print("current Pos : \(currentPosition)")
        }
        
        completion(true, nil)
        
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
    
    private func createBody(data: Data, filePath: String, fileName: String, boundary: String) throws -> InputStream{
        let body = try createBodyWithData(data: data, filePath: filePath, fileName: fileName, boundary: boundary)
        let inputStream = InputStream(data: body)
        return inputStream
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
    
    
    
    //MARK: Upload big video file
    public func uploadBigVideoFile(videoUri: String, fileName: String, filePath: String, url: URL, completion: @escaping (Bool, Response?) -> ()){
        let apiPath = self.environnement + videoUri
        let boundary = generateBoundaryString()
        var datas: [[String:String]] = []
        let data = try? Data(contentsOf: url)
        let dataLen = data!.count
        let chunkSize = ((1024 * 1000) * 30) // MB
        let fullChunks = Int(dataLen / chunkSize)
        let totalChunks = fullChunks + (dataLen % 1024 != 0 ? 1 : 0)
        var initialChunk = 0
        var maxChunk = 0
        
        var chunk:Data = Data()
        var chunks:[Data] = [Data]()
        
        let concurrentQueue = DispatchQueue(label: "com.queue.Concurrent", attributes: .concurrent)
        let semaphore = DispatchSemaphore(value: 2)
        
        
        for chunkCounter in 0..<totalChunks {
            maxChunk = initialChunk + chunkSize
            let chunkBase = chunkCounter * chunkSize
            var diff = chunkSize
            if(chunkCounter == totalChunks - 1) {
                diff = dataLen - chunkBase
                maxChunk = dataLen
            }
            let range:Range<Data.Index> = (chunkBase..<(chunkBase + diff))
            chunk = data!.subdata(in: range)
            chunks.append(chunk)
            
            let element = ["chunkMin":initialChunk.description, "chunkMax": (maxChunk - 1).description, "fullChunk": dataLen.description, "chunkNumber": chunkCounter.description] as [String : String]
            datas.append(element)
            initialChunk = maxChunk
        }
        
        for i in 0..<totalChunks {
            concurrentQueue.async {
                let bytes = datas[i]
                let name = "file\(i)"
                semaphore.wait()
                self.requestUploadHeavyVideo(apiPath: apiPath, boundary: boundary, fileName: name, filePath: filePath, fileSizeMax: bytes["chunkMax"]!, fileSizeMin: bytes["chunkMin"]!, fileSize: bytes["fullChunk"]!, number: i, maxChunk: totalChunks, data: chunks[i], semaphore: semaphore){(crea, resp) in
                    if(crea){
                        completion(true, resp)
                    }else{
                        completion(false, resp)
                    }
                }
            }
        }
    }
    
    private func requestUploadHeavyVideo(apiPath: String, boundary: String, fileName: String, filePath: String, fileSizeMax: String, fileSizeMin: String, fileSize: String, number: Int, maxChunk:Int, data: Data, semaphore: DispatchSemaphore, completion: @escaping (Bool, Response?) -> ()){
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "POST"
        request.setValue("bytes \(fileSizeMin)-\(fileSizeMax)/\(fileSize)", forHTTPHeaderField: "Content-Range")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? createBodyWithData(data: data, filePath: filePath, fileName: fileName, boundary: boundary)
        
        var resp: Response?
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            self.sumChunk = self.sumChunk + ( number + 1)
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode{
            case 200, 201:
                if(json != nil){
                    if(json == nil){
                        resp = nil
                        completion(false, resp)
                    }
                }
            case 400:
                let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                resp = Response(url: json!["type"] as? String, statusCode: stringStatus, message: json!["title"] as? String)
                completion(false, resp)
            default:
                let stringStatus = String(json!["status"] as? Int ?? httpResponse!.statusCode)
                resp = Response(url: json!["type"] as? String, statusCode: stringStatus, message: json!["title"] as? String)
                completion(false, resp)
            }
            semaphore.signal()
            
            //check if all chunk have been uploaded before completion
            let total = ((maxChunk * (maxChunk + 1 )) / 2)
            if(self.sumChunk == total){
                completion(true, resp)
            }
        })
        task.resume()
    }
    
    
    /// Get file size in Bytes
    /// Retrun optional UInt64
    func fileSizeInBytes(fromPath path: String) -> Int? {
        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
              let fileSize = size as? Int else {
            return nil
        }
        return fileSize
    }
    
    
    //MARK: Get video by id
    public func getVideoByID(videoId: String, completion: @escaping (Video?, Response?) -> ()){
        var video: Video?
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/" + videoId
        var request = URLRequest(url: URL(string: apiPath)!)
        
        request.httpMethod = "Get"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        
        let session = URLSession.shared
        TaskExecutor().execute(session: session, request: request, group: group){ (data, response) in
            if(data != nil){
                let jsonData = try? JSONSerialization.data(withJSONObject:data!)
                video = try? self.decoder.decode(Video.self, from: jsonData!)
            }
            completion(video, response)
        }
        group.wait()
    }
    
    //MARK: Get all videos
    public func getAllVideos(completion: @escaping ([Video], Response?) -> ()){
        var videos: [Video] = []
        let path = self.environnement + ApiPaths.videos.rawValue
        var nbItems = self.pagination.getNbOfItems(apiPath: path)
        var resp: Response?
        
        if(nbItems > 0){
            nbItems = nbItems - 1
        }
        for number in (0...nbItems){
            let apiPath = "\(path)?currentPage=\(number + 1)&pageSize=25"
            
            var request = URLRequest(url: URL(string: apiPath)!)
            request.httpMethod = "Get"
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
            let group = DispatchGroup()
            group.enter()
            
            let session = URLSession.shared
            
            TaskExecutor().execute(session: session, request: request, group: group){ (data, response) in
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
        
        var request = URLRequest(url: URL(string: apiPath)!)
        request.httpMethod = "DELETE"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        let group = DispatchGroup()
        group.enter()
        
        var isDeleted = false
        var resp: Response?
        
        let session = URLSession.shared
        
        TaskExecutor().execute(session: session, request: request, group: group){(data, response) in
            if(data != nil){
                isDeleted = true
                completion(isDeleted, resp)
            }else{
                resp = response
                completion(isDeleted, resp)
            }
        }
        group.wait()
    }
    
    //MARK: Update video
    public func updateVideo(video: Video, completion: @escaping (Bool, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(String(describing: video.videoId!))"
        
        var updated = false
        var resp: Response?
        
        let body = [
            "title": video.title!,
            "description": video.description!,
            "public": video.isPublic!,
            "panoramic": video.isPanoramic!
        ] as Dictionary<String, AnyObject>
        var request = URLRequest(url: URL(string: apiPath)!)
        request.httpMethod = "PATCH"
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        let group = DispatchGroup()
        group.enter()
        
        let session = URLSession.shared
        TaskExecutor().execute(session: session, request: request, group: group){ (data, response) in
            let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
            if(json != nil){
                if(data != nil){
                    updated = true
                    completion(updated, resp)
                }else{
                    resp = response
                    completion(updated, resp)
                }
            }
        }
        group.wait()
        
    }
    
    //MARK: Get video status
    public func getStatus(videoId: String, completion: @escaping (Status?, Response?) -> ()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/" + videoId + ApiPaths.status.rawValue
        
        var status: Status?
        var resp: Response?
        
        var request = URLRequest(url: URL(string: apiPath)!)
        request.httpMethod = "Get"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        
        
        let session = URLSession.shared
        TaskExecutor().execute(session: session, request: request){ (data, response) in
            if(data != nil){
                status = try! self.decoder.decode(Status.self, from: data!)
                completion(status, resp)
            }
            else{
                resp = response
                completion(status, resp)
            }
        }
    }
    
    //MARK: Pick Thumbnail
    public func pickThumbnail(videoId: String, timecode: String, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.thumbnail.rawValue
        
        let body = [
            "timecode": timecode,
        ] as Dictionary<String, String>
        
        var request = URLRequest(url: URL(string: apiPath)!)
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        var isChanged = false
        var resp: Response?
        
        let session = URLSession.shared
        
        TaskExecutor().execute(session: session, request: request){ (data, response) in
            if(data != nil){
                isChanged = true
                completion(isChanged, resp)
            }else{
                resp = response
                completion(isChanged, resp)
            }
        }
    }
    
    
    //MARK: Uplaod an image as Thumbnail
    public func uploadImageThumbnail(videoId: String, url: URL, filePath: String, fileName: String, imageData: Data, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.videos.rawValue + "/\(videoId)" + ApiPaths.thumbnail.rawValue
        
        let boundary = generateBoundaryString()
        
        var request = URLRequest(url: URL(string: apiPath)!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("\(self.tokenType!) \(self.key!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? createBodyWithData(data: imageData, filePath: filePath, fileName: fileName, boundary: boundary)
        var isChanged = false
        var resp: Response?
        
        let session = URLSession.shared
        TaskExecutor().execute(session: session, request: request){ (data, response) in
            if(data != nil){
                isChanged = true
                completion(isChanged, resp)
            }else{
                resp = response
                completion(isChanged,resp)
            }
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
