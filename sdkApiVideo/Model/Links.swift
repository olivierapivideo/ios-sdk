//
//  Links.swift
//  sdkApiVideo
//
//  Created by romain PETIT on 02/03/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import Foundation

public struct Links: Codable{
    public var rel: String?
    public var uri: String?
    
    public init(rel: String?, uri: String?){
        self.rel = rel
        self.uri = uri
    }
    
    enum CodingKeys : String, CodingKey {
        case rel
        case uri
    }
}
