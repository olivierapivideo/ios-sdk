//
//  HelloWorld.swift
//  sdkApiVideo
//
//  Created by Romain on 01/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

public class HelloWorld {
    let hello = "Hello"

    public init() {}
    
    public func hello(to whom: String) -> String {
        return "Hello \(whom)"
    }
}
