//
//  Client.swift
//  sdkApiVideo
//
//  Created by Romain on 01/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public class Client{
    private var tokenType: String = ""
    private var refreshToken: String = ""
    private var exprireIn: Int = 0
    private var accessToken: String = ""
    private var environnement: String = ""
    
    public var videoApi: VideoApi!
    public var playerApi: PlayerApi!
    public var liveStreamApi: LiveStreamApi!
    public var analyticsLiveApi: AnalyticsLiveApi!
    public var analyticsVideoApi: AnalyticsVideoApi!
    public var captionApi: CaptionApi!
    public var chapterApi: ChapterApi!
    

    public init(){}
    
    private func create(key: String, completion: @escaping (Bool, Response?) ->()){
        let apiPath = ApiPaths.apiVideoProduction.rawValue + ApiPaths.createProduction.rawValue
        let body = ["apiKey": key] as Dictionary<String, String>
        var request = RequestsBuilder().postClientUrlRequestBuilder(apiPath: apiPath)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let group = DispatchGroup()
        group.enter()
        
        var resp: Response?
        var created = false
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){(data,response) in
            if(data != nil){
                let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>

                self.accessToken = json?["access_token"] as! String
                self.tokenType = json?["token_type"] as! String
                self.videoApi = VideoApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.playerApi = PlayerApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.liveStreamApi = LiveStreamApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.analyticsLiveApi = AnalyticsLiveApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.analyticsVideoApi = AnalyticsVideoApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.captionApi = CaptionApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                self.chapterApi = ChapterApi(tokenType: self.tokenType, key: self.accessToken, environnement: self.environnement)
                created = true
                resp = nil
                completion(created, resp)
            }else{
                resp = response
                completion(created, resp)
            }
        }
        group.wait()
    }
    
    public func createProduction(key: String, completion: @escaping (Bool, Response?) ->()){
        self.environnement = ApiPaths.apiVideoProduction.rawValue
        create(key: key){(data, response) in
            completion(data,response)
        }
    }
    
    public func createSandbox(key: String, completion: @escaping (Bool, Response?) ->()){
        self.environnement = ApiPaths.apiVideoSandbox.rawValue
        create(key: key){(data, response) in
            completion(data,response)
        }
    }
    
    public func getAccessToken() -> String {
        return self.accessToken
    }
    
    public func getTokenType() -> String {
        return self.tokenType
    }
    
    public func getEnvironnement() -> String {
        return self.environnement
    }
    
    
}
