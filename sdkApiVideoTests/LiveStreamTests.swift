//
//  LiveStreamTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 24/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class LiveStreamTests: XCTestCase {
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
    //MARK: test Create Live Stream Success
    func testCreate_success(){
        let expectation = self.expectation(description: "request should succeed")
        let name = "title_test"
        let record = false
        let playerId = "pl66GVxFXe0iG80MsxuY8mJy"
        var liveStreamApi: LiveStreamApi!
        
        var isAuthentified = false
        var isCreated = false
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            liveStreamApi.create(name: name, record: record, playerId: playerId){(created, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isCreated = created
                    response = resp
                }else{
                    expectation.fulfill()
                    isCreated = created
                    response = resp
                }
            }
        }else{
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isCreated)
        XCTAssertNil(response)
        
    }
    //MARK: test Get Live Stream By Id Success
    func testGetLiveById_success(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li33O9QnR8RZb6DXPYdhdB1n"
        var isAuthentified = false
        var liveStreamApi: LiveStreamApi!
        var liveStream: LiveStream?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            liveStreamApi.getLiveStreamById(liveStreamId: liveStreamId){(live, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    liveStream = live
                    response = resp
                }else{
                    expectation.fulfill()
                    liveStream = live
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(liveStream)
        XCTAssertNil(response)
    }
    //MARK: test Get All Live Stream Success
    func testGetAllLives_success(){
        let expectation = self.expectation(description: "request should succeed")
        var isAuthentified = false
        var liveStreamApi: LiveStreamApi!
        var liveStreams: [LiveStream]?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if isAuthentified{
            liveStreamApi.getAllLiveStreams(){(lives, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    liveStreams = lives
                    response = resp
                }else{
                    expectation.fulfill()
                    liveStreams = lives
                    response = resp
                }
            }
        }
        print("nb lives : \(liveStreams?.count)")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(liveStreams)
        XCTAssertNil(response)
        XCTAssertTrue(liveStreams!.count >= 0, "the list must be greater than 0 and must not be null")
        
    }
    //MARK: test Update Live Stream Success
    func testUpdateLiveStream_success(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        var isAuthentified = false
        var liveStreamApi: LiveStreamApi!
        let liveStreamId = "li33O9QnR8RZb6DXPYdhdB1n"
        var updated_live: LiveStream?
        
        
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            liveStreamApi.getLiveStreamById(liveStreamId: liveStreamId){ (live, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    print("error : \((resp?.statusCode)!) - \((resp?.message)!)")
                }else{
                    updated_live = live
                }
                
            }
            if(updated_live != nil){
                updated_live!.name = "nom modifié"
                liveStreamApi.updateLiveStream(liveId: updated_live!.liveStreamId, name: updated_live?.name, record: updated_live!.record, playerId: updated_live!.playerId){ (updated, resp) in
                    if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                        expectation.fulfill()
                        response = resp
                        isUpdated = updated
                    }else{
                        expectation.fulfill()
                        response = resp
                        isUpdated = updated
                    }
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    //MARK: test Delete Live Stream Success
    func testDeleteLiveStream_success(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li27z51dpKktFmpYg8Yg4Wrf"
        var isAuthentified = false
        var liveStreamApi: LiveStreamApi!
        var isDeleted = false
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            liveStreamApi.deleteLiveStream(liveStreamId: liveStreamId){ (deleted, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isDeleted = deleted
                    response = resp
                }else{
                    expectation.fulfill()
                    isDeleted = deleted
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(isDeleted)
        XCTAssertNil(response)
    }
    //MARK: test Upload Thumbnail Live Stream Success
    func testUploadThumbnail_success(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "lifoJ7EV4LeIYAXhT1LDz0x"
        var isAuthentified = false
        var liveStreamApi: LiveStreamApi!
        let filename = "foret.jpg"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "shopping-basket", ofType: "png")!
        let url = bundle.url(forResource: "shopping-basket", withExtension: "png")!
        let testImage = UIImage(named: "shopping-basket", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imagedata = testImage?.pngData()
        var isUploaded = false
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            liveStreamApi.uploadImageThumbnail(liveStreamId: liveStreamId, url: url, filePath: filepath, fileName: filename, imageData: imagedata!){(uploaded, resp) in
                if uploaded{
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }else{
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUploaded)
        print("response : \(String(describing: response))")
        XCTAssertNil(response)
    }
    //MARK: test Delete Thumbnail Live Stream Success
    func testDeleteThumbnail_success(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let liveStreamId = "li5a6YxmyJpM9xkbC4l9qVKZ"
        var liveStreamApi: LiveStreamApi!

        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi

            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            liveStreamApi.deleteThumbnail(liveStreamId: liveStreamId){ (deleted, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                    isDeleted = deleted
                }else{
                    expectation.fulfill()
                    response = resp
                    isDeleted = deleted
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isDeleted)
        print("response : \(String(describing: response))")
        XCTAssertNil(response)
    }
    
}
