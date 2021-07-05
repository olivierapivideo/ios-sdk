//
//  AnalyticsVideoTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 21/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class AnalyticsVideoTests: Common {
    var analyticsVideoApi: AnalyticsVideoApi?
    
    override func setUp() {
        super.setUp()
        self.analyticsVideoApi = self.authClient.analyticsVideoApi
    }
    
    func testSearchVideoAnalyticsById_success() throws {
        try XCTSkipIf(getApiKey() == nil)
        let expectation = self.expectation(description: "request should succeed")
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.createVideo() { (v) in
            self.analyticsVideoApi!.searchVideoAnalyticsById(idVideo: v.videoId!){(analytics, resp) in
                analyticsData = analytics
                response = resp
                self.deleteVideo(video: v)
                expectation.fulfill()
            }
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        print("nb data = \(String(describing: analyticsData?.count))")
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    // wrong id
    // there is an issue with the api, so right now the analyticsData count will be 0 and response is nil
    // otherwise "response" should not be nil
    // and "analyticsData count is 0 
    func testSearchVideoAnalyticsById_error() throws {
        try XCTSkipIf(getApiKey() == nil)
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "viwywar"
        var analyticsData: [AnalyticData]?
        var response: Response?
         
        self.analyticsVideoApi!.searchVideoAnalyticsById(idVideo: videoId){(analytics, resp) in
            analyticsData = analytics
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        print("nb data = \(String(describing: analyticsData?.count))")
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }

}
