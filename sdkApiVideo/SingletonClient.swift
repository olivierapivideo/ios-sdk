//
//  SingletonClient.swift
//  sdkApiVideo
//
//  Created by Romain on 07/10/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

class SingletonClient{
    private static var sharedNetworkManager: SingletonClient = {
        let networkManager = SingletonClient(baseURL: API.baseURL)

        // Configuration
        // ...

        return networkManager
    }()
    
    
}
