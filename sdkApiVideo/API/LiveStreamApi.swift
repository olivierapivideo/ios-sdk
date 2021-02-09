//
//  LiveStreamApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 24/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation
import HaishinKit
import AVFoundation
import VideoToolbox

public class LiveStreamApi{
    public let qualities = ["240p", "360p", "480p", "720p", "1080p", "2160p"]
    let sampleRate: Double = 44_100
    private static let maxRetryCount: Int = 5
    private var retryCount: Int = 0
    private var tokenType: String!
    private var key: String!
    private var environnement: String!
    private let pagination : Pagination!
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var rtmpStream: RTMPStream!
    private var rtmpConnection = RTMPConnection()
    private var currentPosition: AVCaptureDevice.Position = .back
    private var livestreamkey: String?
    
    public init(tokenType: String, key: String, environnement: String){
        self.tokenType = tokenType
        self.key = key
        self.environnement = environnement
        self.pagination = Pagination(tokenType: tokenType, key: key)
    }
    
    //MARK: Create LiveStream
    public func create(name: String, record: Bool?, playerId: String?, completion: @escaping(Bool, Response?)->()){
        let apiPath = self.environnement  + ApiPaths.liveStream.rawValue
        var created = false
        var resp: Response?
        var body = [
            "name" : name,
            ] as Dictionary<String, AnyObject>
        if(record != nil){
            body["record"] = record as AnyObject?
        }
        if(playerId != nil){
            body["playerId"] = playerId as AnyObject?
        }
        var request = RequestBuilder().postUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = RequestBuilder().urlSessionBuilder()
        TaskExecutor().execute(session: session, request: request){(data, response) in
            if(data != nil){
                created = true
                completion(created, resp)
            }else{
                resp = response
                completion(created, resp)
            }
        }
    }
    //MARK: Create Basic LiveStream
    // (no player specified)
    public func create(name: String, record: Bool, completion: @escaping(Bool, Response?)->()){
        create(name: name, record: record, playerId: nil){(data, response) in
            completion(data, response)
        }
    }
    //MARK: Create Basic LiveStream
    // (nothing specified)
    public func create(name: String, completion: @escaping(Bool, Response?)->()){
        create(name: name, record: nil, playerId: nil){(data, response) in
            completion(data, response)
        }
    }
    //MARK: Create Basic LiveStream
    // (no record specified)
    public func create(name: String, playerId: String, completion: @escaping(Bool, Response?)->()){
        create(name: name, record: nil, playerId: playerId){(data, response) in
            completion(data, response)
        }
    }
    
    
    //MARK: Get Live Stream By Id
    public func getLiveStreamById(liveStreamId: String, completion: @escaping (LiveStream?, Response?)->()){
        var liveStream: LiveStream?
        var resp: Response?
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/" + liveStreamId
        let request = RequestBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
                
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestBuilder().urlSessionBuilder()
        TaskExecutor().execute(session: session, request: request, group: group){(data, response) in
            if(data != nil){
                liveStream = try! self.decoder.decode(LiveStream.self, from: data!)
                completion(liveStream, resp)
            }else{
                resp = response
                completion(liveStream, resp)
            }
        }
        group.wait()
    }
    //MARK: Get All LiveStream
    public func getAllLiveStreams(completion: @escaping ([LiveStream], Response?)->()){
        var liveStreams: [LiveStream] = []
        let path = self.environnement + ApiPaths.liveStream.rawValue
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
                        let live = try? self.decoder.decode(LiveStream.self, from: jsonData!)
                        liveStreams.append(live!)
                    }
                }else{
                    resp = response
                    completion(liveStreams, resp)
                }
            }
            group.wait()
        }
        completion(liveStreams,resp)
    }
    //MARK: Update Live Stream Full
    public func updateLiveStream(liveId: String, name: String?, record: Bool?, playerId: String?, completion: @escaping (Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/\(liveId)"
        var body = [:] as Dictionary<String, Any>
        
        if(name != nil){
            body["name"] = name
        }
        if(record != nil){
            body["record"] = record
        }
        if(playerId != nil){
            body["playerId"] = playerId
        }
                
        var request = RequestBuilder().patchUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let group = DispatchGroup()
        group.enter()
        
        var updated = false
        var resp: Response?
        
        let session = RequestBuilder().urlSessionBuilder()
        TaskExecutor().execute(session: session, request: request, group: group){(data, response) in
            if(data != nil){
                updated = true
                completion(updated, resp)
            }else{
                resp = response
                completion(updated, resp)
            }
        }
        group.wait()
    }
    //MARK: Update Live Stream name
    public func updateLiveStream(liveId: String, name: String, completion: @escaping (Bool, Response?)->()){
        updateLiveStream(liveId: liveId, name: name, record: nil, playerId: nil){ (data, response) in
            completion(data, response)
        }
    }
    //MARK: Update Live Stream record
    public func updateLiveStream(liveId: String, record: Bool, completion: @escaping (Bool, Response?)->()){
        updateLiveStream(liveId: liveId, name: nil, record: record, playerId: nil){ (data, response) in
            completion(data, response)
        }
    }
    //MARK: Update Live Stream playerId
    public func updateLiveStream(liveId: String, playerId: String, completion: @escaping (Bool, Response?)->()){
        updateLiveStream(liveId: liveId, name: nil, record: nil, playerId: playerId){ (data, response) in
            completion(data, response)
        }
    }
    //MARK: Update Live Stream name and record
    public func updateLiveStream(liveId: String, name: String, record: Bool, completion: @escaping (Bool, Response?)->()){
        updateLiveStream(liveId: liveId, name: name, record: record, playerId: nil){ (data, response) in
            completion(data, response)
        }
    }
    //MARK: Update Live Stream name and player
    public func updateLiveStream(liveId: String, name: String, playerId: String, completion: @escaping (Bool, Response?)->()){
        updateLiveStream(liveId: liveId, name: name, record: nil, playerId: playerId){ (data, response) in
            completion(data, response)
        }
    }
    //MARK: Update Live Stream record and player
    public func updateLiveStream(liveId: String, record: Bool, playerId: String, completion: @escaping (Bool, Response?)->()){
        updateLiveStream(liveId: liveId, name: nil, record: record, playerId: playerId){ (data, response) in
            completion(data, response)
        }
    }
    
    
    
    //MARK: Delete Live Stream
    public func deleteLiveStream(liveStreamId: String, completion: @escaping (Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/\(liveStreamId)"
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
    
    //MARK: Uplaod Thumbnail
    public func uploadImageThumbnail(liveStreamId: String, url: URL, filePath: String, fileName: String, imageData: Data, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/\(liveStreamId)" + ApiPaths.thumbnail.rawValue
        let boundary = generateBoundaryString()
        var request = RequestBuilder().postUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? createBodyWithData(data: imageData, filePath: filePath, fileName: fileName, boundary: boundary)
        
        var isChanged = false
        var resp: Response?
        
        let session = RequestBuilder().urlSessionBuilder()
        TaskExecutor().execute(session: session, request: request){(data, response) in
            if(data != nil){
                isChanged = true
                completion(isChanged, resp)
            }else{
                resp = response
                completion(isChanged, resp)
            }
        }
    }
    
    public func deleteThumbnail(liveStreamId: String, completion: @escaping (Bool, Response?)->()){
        let apiPath = self.environnement + ApiPaths.liveStream.rawValue + "/\(liveStreamId)" + ApiPaths.thumbnail.rawValue
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
    
    public func StartLiveStreamFlux(liveStream: LiveStream, captureQuality: String, streamQuality: String, fps: Float64){
        
        self.livestreamkey = liveStream.streamKey
        
        rtmpConnection.connect(ApiPaths.rtmpServerUrl.rawValue)
        rtmpStream = RTMPStream(connection: rtmpConnection)
        if let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) {
            rtmpStream.orientation = orientation
        }
        rtmpStream.setZoomFactor(CGFloat(0), ramping: true, withRate: 5.0)
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio)) { error in
            print("======== Audio Flux Error ==========")
            print(error.description)
        }
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .back)) { error in
            print("======== Camera Flux Error ==========")
            print(error.description)
        }
        
        
        setCaptureVideo(quality: captureQuality, fps: fps)
        setStreamVideoQuality(quality: streamQuality)
        
        
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(on(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    public func rotateCamera(){
        let position: AVCaptureDevice.Position = currentPosition == .back ? .front : .back
        rtmpStream.attachCamera(DeviceUtil.device(withPosition: position)) { error in
            print(error.description)
        }
        currentPosition = position
    }
    
    private func setStreamVideoQuality(quality: String){
        switch quality {
        case "240p":
            // 352 * 240
            rtmpStream.videoSettings = [
                .width: 352,
                .height: 240,
                .bitrate: 400 * 1000, // video output bitrate
                .maxKeyFrameIntervalDuration: 2,// key frame / sec
            ]
            
        case "360p":
            // 480 * 360
            rtmpStream.videoSettings = [
                .width: 480,
                .height: 360,
                .bitrate: 800 * 1000, // video output bitrate
                .maxKeyFrameIntervalDuration: 2, // key frame / sec
            ]
            
        case "480p":
            // 858 * 480
            rtmpStream.videoSettings = [
                .width: 858,
                .height: 480,
                .bitrate: 1200 * 1000, // video output bitrate
                .maxKeyFrameIntervalDuration: 2, // key frame / sec
            ]
        case "720p":
            // 1280 * 720
            rtmpStream.videoSettings = [
                .width: 1280,
                .height: 720,
                .bitrate: 2250 * 1000, // video output bitrate
                .maxKeyFrameIntervalDuration: 2, // key frame / sec
            ]
        case "1080p":
            // 1920 * 1080
            rtmpStream.videoSettings = [
                .width: 1920,
                .height: 1080,
                .profileLevel: kVTProfileLevel_H264_High_4_0,
                .bitrate: 4500 * 1000, // video output bitrate
                .maxKeyFrameIntervalDuration: 2, // key frame / sec
            ]
        case "2160p":
            // 3860 * 2160
            rtmpStream.videoSettings = [
                .width: 3860,
                .height: 2160,
                .profileLevel: kVTProfileLevel_H264_High_AutoLevel,
                .bitrate: 160000 * 1000, // video output bitrate
                .maxKeyFrameIntervalDuration: 2, // key frame / sec
            ]
        default:
            rtmpStream.videoSettings = [
                .width: 480,
                .height: 360,
                .bitrate: 400 * 1000, // video output bitrate
                .maxKeyFrameIntervalDuration: 2, // key frame / sec
            ]
        }
    }
    
    private func setCaptureVideo(quality: String, fps: Float64){
        switch quality {
        case "240p":
            // 352 * 240
            rtmpStream.captureSettings = [
                .fps: fps,
                .sessionPreset: AVCaptureSession.Preset.inputPriority,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
            
            rtmpStream.audioSettings = [
                .muted: false, // mute audio
                .bitrate: 128 * 1000,
            ]
        case "360p":
            // 480 * 360
            rtmpStream.captureSettings = [
                .fps: fps,
                .sessionPreset: AVCaptureSession.Preset.inputPriority,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
            
            rtmpStream.audioSettings = [
                .muted: false, // mute audio
                .bitrate: 128 * 1000,
            ]
            
        case "480p":
            // 858 * 480
            rtmpStream.captureSettings = [
                .fps: fps,
                .sessionPreset: AVCaptureSession.Preset.inputPriority,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
            
            rtmpStream.audioSettings = [
                .muted: false, // mute audio
                .bitrate: 128 * 1000,
            ]
        case "720p":
            // 1280 * 720
            rtmpStream.captureSettings = [
                .fps: fps,
                .sessionPreset: AVCaptureSession.Preset.inputPriority,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
            
            rtmpStream.audioSettings = [
                .muted: false, // mute audio
                .bitrate: 128 * 1000,
            ]
        case "1080p":
            // 1920 * 1080
            rtmpStream.captureSettings = [
                .fps: fps,
                .sessionPreset: AVCaptureSession.Preset.inputPriority,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
            rtmpStream.audioSettings = [
                .muted: false, // mute audio
                .bitrate: 128 * 1000,
            ]
        case "2160p":
            // 3860 * 2160
            rtmpStream.captureSettings = [
                .fps: fps,
                .sessionPreset: AVCaptureSession.Preset.inputPriority,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
            
            rtmpStream.audioSettings = [
                .muted: false, // mute audio
                .bitrate: 128 * 1000,
            ]
        default:
            rtmpStream.captureSettings = [
                .fps: 24,
                .sessionPreset: AVCaptureSession.Preset.inputPriority,
                .continuousAutofocus: true,
                .continuousExposure: true,
                .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
            ]
            
            rtmpStream.audioSettings = [
                .muted: false, // mute audio
                .bitrate: 128 * 1000,
            ]
        }
    }
    
    public func StopLiveStreamFlux(){
        rtmpStream.close()
        rtmpStream.dispose()
        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.removeEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
    }
    
    public func SetUpFpsRecord(fps: Int){
        rtmpStream.captureSettings[.fps] = fps
    }
    
    @objc
    private func on(_ notification: Notification) {
        guard let orientation = DeviceUtil.videoOrientation(by: UIApplication.shared.statusBarOrientation) else {
            return
        }
        rtmpStream.orientation = orientation
    }
    
    
    
    @objc private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            retryCount = 0
            //            rtmpStream!.publish(Preference.defaultInstance.streamName!)
            rtmpStream!.publish(self.livestreamkey!)
        // sharedObject!.connect(rtmpConnection)
        case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
            guard retryCount <= LiveStreamApi.maxRetryCount else {
                return
            }
            Thread.sleep(forTimeInterval: pow(2.0, Double(retryCount)))
            //            rtmpConnection.connect(Preference.defaultInstance.uri!)
            rtmpConnection.connect("rtmp://broadcast.api.video/s")
            retryCount += 1
        default:
            break
        }
    }
    
    @objc
    private func rtmpErrorHandler(_ notification: Notification) {
        let e = Event.from(notification)
        print("rtmpErrorHandler: \(e)")
        DispatchQueue.main.async {
            self.rtmpConnection.connect("rtmp://broadcast.api.video/s")
        }
    }
    
    
    
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
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
}
