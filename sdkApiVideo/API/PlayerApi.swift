//
//  PlayerApi.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 03/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public class PlayerApi{
    
    private var tokenType: String!
    private var key: String!
    private var environnement: String!
    private let pagination : Pagination!
    
    public init(tokenType: String, key: String, environnement: String){
        self.tokenType = tokenType
        self.key = key
        self.environnement = environnement
        self.pagination = Pagination(tokenType: tokenType, key: key)
    }
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    //MARK: Create Player
    public func createPlayer(player: Player, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.players.rawValue
        let body = [
            "shapeMargin" : player.shapeMargin!,
            "shapeRadius" : player.shapeRadius!,
            "shapeAspect" : player.shapeAspect!,
            "shapeBackgroundTop" : player.shapeBackgroundTop!,
            "shapeBackgroundBottom" : player.shapeBackgroundBottom!,
            "text" : player.text!,
            "link" : player.link!,
            "linkHover" : player.linkHover!,
            "linkActive" : player.linkActive!,
            "trackPlayed" : player.trackPlayed!,
            "trackUnplayed" : player.trackUnplayed!,
            "trackBackground" : player.trackBackground!,
            "backgroundTop" : player.backgroundTop!,
            "backgroundBottom" : player.backgroundBottom!,
            "backgroundText" : player.backgroundText!,
            "enableApi" : player.enableApi!,
            "enableControls" : player.enableControls!,
            "forceAutoplay" : player.forceAutoplay!,
            "hideTitle" : player.hideTitle!,
            "forceLoop" : player.forceLoop!,
            ] as Dictionary<String, AnyObject>

        var request = RequestsBuilder().postUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        let session = RequestsBuilder().urlSessionBuilder()
        
        TasksExecutor().execute(session: session, request: request){(data, response) in
            completion(data != nil, response)
        }
    }
    
    //MARK: Get All Players
    public func getAllPlayers(completion: @escaping ([Player], Response?) ->()){
        var players: [Player] = []
        let path = self.environnement + ApiPaths.players.rawValue
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
            TasksExecutor().execute(session: session, request: request, group: group){ (data, response) in
                if(data != nil){
                    let json = try? JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject>
                    for d in json!["data"] as! [AnyObject]{
                        let jsonData = try? JSONSerialization.data(withJSONObject:d)
                        let player = try? self.decoder.decode(Player.self, from: jsonData!)
                        players.append(player!)
                    }
                }else{
                    resp = response
                    completion(players, resp)
                }
            }
            group.wait()
        }
        completion(players,resp)
    }
    
    //MARK: Get Player with Id
    public func getPlayerById(playerId: String, completion: @escaping (Player?, Response?) ->()){
        var player: Player?
        var resp: Response?
        let apiPath = self.environnement + ApiPaths.players.rawValue + "/" + playerId
        let request = RequestsBuilder().getUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
                
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){ (data, response) in
            if(data != nil){
                player = try! self.decoder.decode(Player.self, from: data!)
                completion(player,resp)
            }else{
                resp = response
                completion(player, resp)
            }
        }
        group.wait()
    }
    
    //MARK: Update Player
    public func updatePlayer(player: Player, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.players.rawValue + "/\(String(describing: player.playerId!))"
        let body = [
            "shapeMargin": player.shapeMargin!,
            "shapeRadius": player.shapeRadius!,
            "shapeAspect": player.shapeAspect!,
            "shapeBackgroundTop": player.shapeBackgroundTop!,
            "shapeBackgroundBottom": player.shapeBackgroundBottom!,
            "text": player.text!,
            "link": player.link!,
            "linkHover": player.linkHover!,
            "linkActive": player.linkActive!,
            "trackPlayed": player.trackPlayed!,
            "trackUnplayed": player.trackUnplayed!,
            "trackBackground": player.trackBackground!,
            "backgroundTop": player.backgroundTop!,
            "backgroundBottom": player.backgroundBottom!,
            "backgroundText": player.backgroundText!,
            "enableApi": player.enableApi!,
            "enableControls": player.enableControls!,
            "forceAutoplay": player.forceAutoplay!,
            "hideTitle": player.hideTitle!,
            "forceLoop" : player.forceLoop!,
            ] as Dictionary<String, AnyObject>
        var request = RequestsBuilder().patchUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let group = DispatchGroup()
        group.enter()
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request, group: group){ (data, response) in
            completion(data != nil, response)
        }
        group.wait()
    }
    
    //MARK: Upload logo
    public func uploadLogo(playerId: String, url: URL, filePath: String, fileName: String, imageData: Data, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.players.rawValue + "/\(playerId)" + ApiPaths.logoPlayer.rawValue
        let boundary = generateBoundaryString()
        var request = RequestsBuilder().postMultipartUrlRequestBuilder(apiPath: apiPath, tokenType: self.tokenType, key: self.key, boundary: boundary)
        request.httpBody = try? createBodyWithData(data: imageData, filePath: filePath, fileName: fileName, boundary: boundary)
        
        let session = RequestsBuilder().urlSessionBuilder()
        TasksExecutor().execute(session: session, request: request){ (data, response) in
            completion(data != nil, response)
        }
    }
    
    //MARK: Delete Player
    public func deletePlayer(playerId: String, completion: @escaping (Bool, Response?) ->()){
        let apiPath = self.environnement + ApiPaths.players.rawValue + "/\(playerId)"
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
