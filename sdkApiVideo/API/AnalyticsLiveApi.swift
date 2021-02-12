//
//  AnalyticsLiveApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 13/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public class AnalyticsLiveApi{
    
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
    
    public func searchLiveAnalyticsById(idLiveStream: String, period: String? = nil, completion: @escaping ([AnalyticData], Response?) -> ()){
        var analyticsData: [AnalyticData] = []
        var nbItems = 0
        
        if(period != nil){
            
            self.pagination.getNbOfItems(apiPath: self.environnement + "\(ApiPaths.analyticsLiveStream.rawValue)\(idLiveStream)?period=\(period!)"){(nb, response) in
                if(response == nil){
                    nbItems = nb
                }
            }
        }else{
            self.pagination.getNbOfItems(apiPath: self.environnement + ApiPaths.analyticsLiveStream.rawValue + idLiveStream){(nb, response) in
                if(response != nil){
                    nbItems = nb
                }
            }

        }
        var resp: Response?
        
        if(nbItems > 0){
            nbItems = nbItems - 1
        }
        for number in (0...nbItems){
            var apiPath = ""
            if(period != nil){
                apiPath = self.environnement + "\(ApiPaths.analyticsLiveStream.rawValue)\(idLiveStream)?\(period!)&currentPage=\(number + 1)&pageSize=25"
            }else{
                apiPath = self.environnement + ApiPaths.analyticsLiveStream.rawValue + idLiveStream + "?currentPage=\(number + 1)&pageSize=25"
            }
            
            let request = RequestsBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
            
            let group = DispatchGroup()
            group.enter()
            
            let session = RequestsBuilder().urlSessionBuilder()
            TasksExecutor().execute(session: session, request: request, group: group){(data, response) in
                if(data != nil){
                    let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                    for data in json!["data"] as! [AnyObject]{
                        
                        let jsonDataSession = try? JSONSerialization.data(withJSONObject:data["session"]!!)
                        let session = try? self.decoder.decode(AnalyticSession.self, from: jsonDataSession!)
                        
                        let jsonDataLocation = try? JSONSerialization.data(withJSONObject:data["location"]!!)
                        let location = try? self.decoder.decode(AnalyticLocation.self, from: jsonDataLocation!)
                        
                        let jsonDataReferrer = try? JSONSerialization.data(withJSONObject:data["referrer"]!!)
                        let referrer = try? self.decoder.decode(AnalyticReferrer.self, from: jsonDataReferrer!)
                        
                        let jsonDataDevice = try? JSONSerialization.data(withJSONObject:data["device"]!!)
                        let device = try? self.decoder.decode(AnalyticDevice.self, from: jsonDataDevice!)
                        
                        let jsonDataOs = try? JSONSerialization.data(withJSONObject:data["os"]!!)
                        let os = try? self.decoder.decode(AnalyticOs.self, from: jsonDataOs!)
                        
                        let jsonDataClient = try? JSONSerialization.data(withJSONObject:data["client"]!!)
                        let client = try? self.decoder.decode(AnalyticClient.self, from: jsonDataClient!)
                        
                        let analyticData = AnalyticData(session: session!, location: location!, referrer: referrer!, device: device!, os: os!, client: client!)
                        
                        analyticsData.append(analyticData)
                    }
                }else{
                    resp = response
                }
            }
            group.wait()
        }
        completion(analyticsData, resp)
    }
}
