//
//  AnalyticsVideoTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 21/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class AnalyticsVideoTests: XCTestCase {
    let authClient = Client()
    
    func testSearchVideoAnalyticsById_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var isAuthentified = false
        var analyticsVideoApi: AnalyticsVideoApi!
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsVideoApi = self.authClient.analyticsVideoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            analyticsVideoApi.searchVideoAnalyticsById(idVideo: videoId){(analytics, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    analyticsData = analytics
                    response = resp
                }else{
                    expectation.fulfill()
                    print("reussi")
                    analyticsData = analytics
                    response = resp
                }
            }
        }
        print("nb data = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    // wrong id
    // there is an issue with the api, so right now the analyticsData count will be 0 and response is nil
    // otherwise "response" should not be nil
    // and "analyticsData count is 0 
    func testSearchVideoAnalyticsById_error(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "viwywar"
        var isAuthentified = false
        var analyticsVideoApi: AnalyticsVideoApi!
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsVideoApi = self.authClient.analyticsVideoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){            
            analyticsVideoApi.searchVideoAnalyticsById(idVideo: videoId){(analytics, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    analyticsData = analytics
                    response = resp
                }else{
                    expectation.fulfill()
                    print("reussi")
                    analyticsData = analytics
                    response = resp
                }
            }
        }
        print("nb data = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }

}
