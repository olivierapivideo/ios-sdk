//
//  AnalyticsLiveStreamTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 14/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class AnalyticsLiveStreamTests: Common {

    var analyticsLiveApi: AnalyticsLiveApi?
        
        override func setUp() {
            super.setUp()
            self.analyticsLiveApi = self.authClient.analyticsLiveApi
        }
    
    // wrong id
    // there is an issue with the api, so right now the analyticsData count will be 0 and response is nil
    // otherwise "response" should not be nil
    // and "analyticsData count is 0 
    func testSearchLiveAnalyticsById_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV"
        var analyticsData: [AnalyticData]?
        var response: Response?
    
        
        self.analyticsLiveApi!.searchLiveAnalyticsById(idLiveStream: liveStreamId){(analytics, resp) in
            analyticsData = analytics
            response = resp
            expectation.fulfill()
        }

        print("nb data = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(analyticsData?.count == 0)
        XCTAssertNil(response)
    }
    
    func testSearchLiveAnalyticsById() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li5wq1x0g0v3AQws2Y5OyqJq"
        var analyticsData: [AnalyticData]?
        var response: Response?
    
        self.analyticsLiveApi!.searchLiveAnalyticsById(idLiveStream: liveStreamId){(analytics, resp) in
            analyticsData = analytics
            response = resp
            expectation.fulfill()
        }
    
        print("nb data = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    func testSearchLiveAnalyticsById_ForADay() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li5wq1x0g0v3AQws2Y5OyqJq"
        let period = "2020-01-13"
        var analyticsData: [AnalyticData]?
        var response: Response?
    
        
        self.analyticsLiveApi!.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
            analyticsData = analytics
            response = resp
            expectation.fulfill()
        }
        
        print("nb data  for a day= \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    
    func testSearchLiveAnalyticsById_ForAWeek() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li5wq1x0g0v3AQws2Y5OyqJq"
        let period = "2020-W01"
        var analyticsData: [AnalyticData]?
        var response: Response?
    
        self.analyticsLiveApi!.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
            analyticsData = analytics
            response = resp
            expectation.fulfill()
        }
        
        print("nb data  for a week = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    func testSearchLiveAnalyticsById_ForAMonth() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        let period = "2020-01"
        var analyticsData: [AnalyticData]?
        var response: Response?
    
        
        self.analyticsLiveApi!.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
            analyticsData = analytics
            response = resp
            expectation.fulfill()
        }
        
        print("nb data  for a month = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }

    func testSearchLiveAnalyticsById_ForAYear() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        let period = "2020"
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.analyticsLiveApi!.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
            analyticsData = analytics
            response = resp
            expectation.fulfill()
        }
        
        print("nb data  for a year = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    func testSearchLiveAnalyticsById_ForADateRange() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        let period = "2020-01-01/2020-01-13"
        var analyticsData: [AnalyticData]?
        var response: Response?
    
        self.analyticsLiveApi!.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
            analyticsData = analytics
            response = resp
            expectation.fulfill()
        }
    
        print("nb data  for a year = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }

}
