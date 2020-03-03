//
//  SourceVideo.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 15/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public class SourceVideo: Codable{
    public var uri: String?
    public var type: String?
    public var liveStream: LiveStreamSource?
    
    init(uri: String?, type: String?, liveStream: LiveStreamSource?) {
        self.uri = uri
        self.type = type
        self.liveStream = liveStream
    }
    
    enum CodingKeys : String, CodingKey {
        case uri
        case type
        case liveStream
    }
}
