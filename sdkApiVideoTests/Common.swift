//
//  Common.swift
//  sdkApiVideoTests
//
//  Created by Olivier Lando on 02/07/2021.
//  Copyright © 2021 Romain. All rights reserved.
//

import XCTest
import Foundation
@testable import sdkApiVideo


class Common: XCTestCase {
    
    let authClient = Client()
    
    override func setUp() {
        let semaphore = DispatchSemaphore(value: 0)
        self.authClient.createSandbox(key: getApiKey()!){ (authentified, resp) in
            if !authentified {
                print("authentified status => \((resp?.statusCode)!) : \((resp?.message)!)")
            }
            semaphore.signal();
        }
          
        semaphore.wait()
    }
    
    func createVideo(completion: @escaping (Video) -> ()) {
        self.authClient.videoApi.initVideo(title: "test", description: "desc") { (video, resp1) in
            completion(video!)
        }
    }
    
    func deleteVideo(video: Video?) {
        self.authClient.videoApi.deleteVideo(videoId: (video?.videoId!)!) { (s, r) in
        }
    }
    
    
    func getApiKey() -> String? {
        let API_KEY: String? = nil // YOUR SANDBOX API KEY HERE
        return ProcessInfo.processInfo.environment["API_KEY"] ?? API_KEY;
    }
    
    func deletePlayer(player: Player?) {
        self.authClient.playerApi?.deletePlayer(playerId: (player?.playerId)!) { (success, response) in
            
        }
    }
    
    func createPlayer(completion: @escaping (Player) -> ()) {
        self.authClient.playerApi?.createPlayer(player: PlayerTests.player_success, completion: { player, response in
            completion(player!)
        })
    }
}
