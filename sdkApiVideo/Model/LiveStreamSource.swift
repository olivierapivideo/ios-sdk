//
//  LiveStreamSource.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 02/03/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct LiveStreamSource: Codable{
    public var liveStreamId: String?
    public var links: [Links]?
    
    public init(liveStreamId: String?, links: [Links]?){
        self.liveStreamId = liveStreamId
        self.links = links
    }
    
    enum CodingKeys : String, CodingKey {
        case liveStreamId
        case links
    }
}
