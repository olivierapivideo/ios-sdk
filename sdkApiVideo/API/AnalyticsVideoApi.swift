//
//  AnalyticsVideoApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 21/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public class AnalyticsVideoApi{
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
    
    public func searchVideoAnalyticsById(idVideo: String, period: String? = nil, completion: @escaping ([AnalyticData], Response?) -> ()){
        var analyticsData: [AnalyticData] = []
        var nbPages = 0
        var resp: Response?
        
        if(period != nil){
            nbPages = self.pagination.getNbOfItems(apiPath: "\(String(describing: self.environnement))\(ApiPaths.analyticsVideo.rawValue)\(idVideo)?period=\(period!)")
        }else{
            nbPages = self.pagination.getNbOfItems(apiPath: self.environnement + ApiPaths.analyticsVideo.rawValue + idVideo)
        }
        
        if(nbPages > 0){
            nbPages = nbPages - 1
        }
        for number in (0...nbPages){
            var apiPath = ""
            if(period != nil){
                apiPath = "\(String(describing: self.environnement))\(ApiPaths.analyticsVideo.rawValue)\(idVideo)?\(period!)&currentPage=\(number + 1)&pageSize=25"
            }else{
                apiPath = self.environnement + ApiPaths.analyticsVideo.rawValue + idVideo + "?currentPage=\(number + 1)&pageSize=25"
            }
            
            let request = RequestsBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
            
            let group = DispatchGroup()
            group.enter()
            
            let session = RequestsBuilder().urlSessionBuilder()
            TasksExecutor().execute(session: session, request: request, group: group){(data, response) in
                if(data != nil){
                    let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                    for d in json!["data"] as! [AnyObject]{
                        
                        let jsonDataSession = try? JSONSerialization.data(withJSONObject:d["session"]!!)
                        let session = try? self.decoder.decode(AnalyticSession.self, from: jsonDataSession!)
                        
                        let jsonDataLocation = try? JSONSerialization.data(withJSONObject:d["location"]!!)
                        let location = try? self.decoder.decode(AnalyticLocation.self, from: jsonDataLocation!)
                        
                        let jsonDataReferrer = try? JSONSerialization.data(withJSONObject:d["referrer"]!!)
                        let referrer = try? self.decoder.decode(AnalyticReferrer.self, from: jsonDataReferrer!)
                        
                        let jsonDataDevice = try? JSONSerialization.data(withJSONObject:d["device"]!!)
                        let device = try? self.decoder.decode(AnalyticDevice.self, from: jsonDataDevice!)
                        
                        let jsonDataOs = try? JSONSerialization.data(withJSONObject:d["os"]!!)
                        let os = try? self.decoder.decode(AnalyticOs.self, from: jsonDataOs!)
                        
                        let jsonDataClient = try? JSONSerialization.data(withJSONObject:d["client"]!!)
                        let client = try? self.decoder.decode(AnalyticClient.self, from: jsonDataClient!)
                        
                        let analyticData = AnalyticData(session: session!, location: location!, referrer: referrer!, device: device!, os: os!, client: client!)
                        
                        analyticsData.append(analyticData)
                    }
                }else{
                    resp = response
                    completion(analyticsData, resp)
                }
            }
            group.wait()
        }
        completion(analyticsData, resp)
    }
}
