//
//  AnalyticsLiveStreamTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 14/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class AnalyticsLiveStreamTests: XCTestCase {
    let authClient = Client()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    // wrong id
    // there is an issue with the api, so right now the analyticsData count will be 0 and response is nil
    // otherwise "response" should not be nil
    // and "analyticsData count is 0 
    func testSearchLiveAnalyticsById_error(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV"
        var isAuthentified = false
        var analyticsLiveApi: AnalyticsLiveApi!
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsLiveApi = self.authClient.analyticsLiveApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            analyticsLiveApi.searchLiveAnalyticsById(idLiveStream: liveStreamId){(analytics, resp) in
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
        XCTAssertTrue(analyticsData?.count == 0)
        XCTAssertNil(response)
    }
    
    func testSearchLiveAnalyticsById(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        var isAuthentified = false
        var analyticsLiveApi: AnalyticsLiveApi!
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsLiveApi = self.authClient.analyticsLiveApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            analyticsLiveApi.searchLiveAnalyticsById(idLiveStream: liveStreamId){(analytics, resp) in
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
    
    func testSearchLiveAnalyticsById_ForADay(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        var analyticsLiveApi: AnalyticsLiveApi!
        let period = "2020-01-13"
        var isAuthentified = false
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsLiveApi = self.authClient.analyticsLiveApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            analyticsLiveApi.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
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
        print("nb data  for a day= \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    
    func testSearchLiveAnalyticsById_ForAWeek(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        var analyticsLiveApi: AnalyticsLiveApi!
        let period = "2020-W01"
        var isAuthentified = false
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsLiveApi = self.authClient.analyticsLiveApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            analyticsLiveApi.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
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
        print("nb data  for a week = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    func testSearchLiveAnalyticsById_ForAMonth(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        var analyticsLiveApi: AnalyticsLiveApi!
        let period = "2020-01"
        var isAuthentified = false
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsLiveApi = self.authClient.analyticsLiveApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            analyticsLiveApi.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
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
        print("nb data  for a month = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }

    func testSearchLiveAnalyticsById_ForAYear(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        var analyticsLiveApi: AnalyticsLiveApi!
        let period = "2020"
        var isAuthentified = false
        var analyticsData: [AnalyticData]?
        var response: Response?
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsLiveApi = self.authClient.analyticsLiveApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            analyticsLiveApi.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
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
        print("nb data  for a year = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }
    
    func testSearchLiveAnalyticsById_ForADateRange(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        var analyticsLiveApi: AnalyticsLiveApi!
        let period = "2020-01-01/2020-01-13"
        var isAuthentified = false
        var analyticsData: [AnalyticData]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                analyticsLiveApi = self.authClient.analyticsLiveApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            analyticsLiveApi.searchLiveAnalyticsById(idLiveStream: liveStreamId, period: period){(analytics, resp) in
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
        print("nb data  for a year = \(String(describing: analyticsData?.count))")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(analyticsData)
        XCTAssertNil(response)
    }

}
