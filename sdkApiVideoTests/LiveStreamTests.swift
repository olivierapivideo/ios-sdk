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
    
    //MARK: test Create Live Stream Success
    func testCreate_success(){
        let expectation = self.expectation(description: "request should succeed")
        let name = "full"
        let record = false
        let playerId = "pt1lAdwkkmCFdJZ6f85o3Izv"
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
    
    //MARK: test Basic Create Live Stream Success
    // NO PLAYER
    func testBasicCreate_success(){
        let expectation = self.expectation(description: "request should succeed")
        let name = "title_test"
        let record = false
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
            liveStreamApi.create(name: name, record: record){(created, resp) in
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
    
    //MARK: test Basic Create Live Stream Success
    // NO Record
    func testNoRecordCreate_success(){
        let expectation = self.expectation(description: "request should succeed")
        let name = "player"
        let playerId = "pt1lAdwkkmCFdJZ6f85o3Izv"
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
            liveStreamApi.create(name: name, playerId: playerId){(created, resp) in
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
    
    //MARK: test Basic Create Live Stream Success
    // NO Record and no player
    func testNothingCreate_success(){
        let expectation = self.expectation(description: "request should succeed")
        let name = "basic"
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
            liveStreamApi.create(name: name){(created, resp) in
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
    
    //MARK:test Create Basic Live Stream Error
    func testBasicCreate_error(){
        let expectation = self.expectation(description: "request should succeed")
        let name = "title_test"
        let record = false
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
            liveStreamApi.create(name: name, record: record){(created, resp) in
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
        XCTAssertFalse(isCreated)
        XCTAssertNotNil(response)
        
    }
    
    //MARK:test Create Live Stream Error
    // player selected does not exist
    func testCreate_error(){
        let expectation = self.expectation(description: "request should succeed")
        let name = "title_test"
        let record = false
        let playerId = "pt3fePLEGw8xS6NF5x5A"
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
        XCTAssertFalse(isCreated)
        XCTAssertNotNil(response)
        
    }
    
    //MARK: test Get Live Stream By Id Success
    func testGetLiveById_success(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "liwSrwKvC6LFStOLe5Awrsp"
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
    
    //MARK: test Get Live Stream By Id Error
    //wrong id
    func testGetLiveById_error(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li3ueibB0OSdA0JUTU"
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
        XCTAssertNil(liveStream)
        XCTAssertNotNil(response)
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
        let liveStreamId = "liwSrwKvC6LFStOLe5Awrsp"
        let playerId = "pt1lAdwkkmCFdJZ6f85o3Izv"
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            liveStreamApi.updateLiveStream(liveId: liveStreamId, name: "new name", record: true, playerId: playerId){(data,resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                }else{
                    expectation.fulfill()
                    isUpdated = true
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: test Update Live Stream Error
    func testUpdateLiveStream_error(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        var isAuthentified = false
        var liveStreamApi: LiveStreamApi!
        let liveStreamId = "li3ueibB0OSdA0JUTUzWb4UU"
        let playerId = "jeiojdioazjdazjiod"
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            liveStreamApi.updateLiveStream(liveId: liveStreamId, name: "new name", record: true, playerId: playerId){(data,resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                }else{
                    expectation.fulfill()
                    isUpdated = true
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUpdated)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Update Live Stream Success
    func testUpdateLiveStream_record_success(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        var isAuthentified = false
        var liveStreamApi: LiveStreamApi!
        let liveStreamId = "liwSrwKvC6LFStOLe5Awrsp"
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            liveStreamApi.updateLiveStream(liveId: liveStreamId,record : false){(data,resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                }else{
                    expectation.fulfill()
                    isUpdated = true
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: test Update Live Stream Error
    func testUpdateLiveStream_record_error(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        var isAuthentified = false
        var liveStreamApi: LiveStreamApi!
        let liveStreamId = "li3ueibB0OSdA0JUTUzWbU"
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                liveStreamApi = self.authClient.liveStreamApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            liveStreamApi.updateLiveStream(liveId: liveStreamId,record : false){(data,resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                }else{
                    expectation.fulfill()
                    isUpdated = true
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUpdated)
        XCTAssertNotNil(response)
    }
    
    
    //MARK: test Delete Live Stream Success
    func testDeleteLiveStream_success(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "liwSrwKvC6LFStOLe5Awrsp"
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
    
    //MARK: test Delete Live Stream Error
    func testDeleteLiveStream_error(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li7IPfB3w1XEzOISfzeq1j8n"
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
        XCTAssertFalse(isDeleted)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Upload Thumbnail Live Stream Success
    func testUploadThumbnail_success(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "liWl49txMbBMJCJBTAXuIyT"
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
        XCTAssertNil(response)
    }
    
    //MARK: test Upload Thumbnail Live Stream Error
    func testUploadThumbnail_error(){
        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li4tTuqrImXBVrYi8XH5Oz"
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
        XCTAssertFalse(isUploaded)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Delete Thumbnail Live Stream Success
    func testDeleteThumbnail_success(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let liveStreamId = "liWl49txMbBMJCJBTAXuIyT"
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
        XCTAssertNil(response)
    }
    
    //MARK: test Delete Thumbnail Live Stream Error
    func testDeleteThumbnail_error(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let liveStreamId = "li4tTuqrImXBVrYi8XH5OT"
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
        XCTAssertFalse(isDeleted)
        XCTAssertNotNil(response)
    }
}
