//
//  LiveStreamTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 24/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class LiveStreamTests: Common {
    var liveStreamApi: LiveStreamApi?
    
    override func setUp() {
        super.setUp()
        self.liveStreamApi = self.authClient.liveStreamApi
    }
    
    
    func deleteLiveStream(live: LiveStream?) {
        self.liveStreamApi?.deleteLiveStream(liveStreamId: (live?.liveStreamId)!) { (s, r) in
        }
    }
    
    //MARK: test Create Live Stream Success
    func testCreate_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let name = "full"
        let record = false
        var livestream: LiveStream?
        var response: Response?
        
        self.createPlayer { p in
            self.liveStreamApi!.create(name: name, record: record, playerId: p.playerId, isPublic: nil){(live, resp) in
                livestream = live
                response = resp
                self.deletePlayer(player: p)
                self.deleteLiveStream(live: livestream!)
                expectation.fulfill()
            }
        }
        
    
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(livestream)
        XCTAssertNil(response)
        
    }
    
    //MARK: test Basic Create Live Stream Success
    // NO PLAYER
    func testBasicCreate_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let name = "title_test"
        let record = false
        var livestream: LiveStream?
        var response: Response?
        
        
        self.liveStreamApi!.create(name: name, record: record){(live, resp) in
            livestream = live
            response = resp
            self.deleteLiveStream(live: livestream!)
            expectation.fulfill()
        }

        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(livestream)
        XCTAssertNil(response)
        
    }
    
    //MARK: test Basic Create Live Stream Success
    // NO Record
    func testNoRecordCreate_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let name = "player"
        var livestream: LiveStream?
        var response: Response?
        
        self.createPlayer { p in
            self.liveStreamApi!.create(name: name, playerId: p.playerId!){(live, resp) in
                livestream = live
                response = resp
                self.deletePlayer(player: p)
                self.deleteLiveStream(live: livestream!)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(livestream)
        XCTAssertNil(response)
        
    }
    
    //MARK: test Basic Create Live Stream Success
    // NO Record and no player
    func testNothingCreate_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let name = "basic"
        var livestream: LiveStream?
        var response: Response?
        
        
        self.liveStreamApi!.create(name: name){(live, resp) in
            livestream = live
            response = resp
            self.deleteLiveStream(live: livestream!)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(livestream)
        XCTAssertNil(response)
        
    }
    
    
    //MARK: test Basic Private Create Live Stream Success
    // NO Record and no player
    func testPrivateCreate_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let name = "private"
        var livestream: LiveStream?
        var response: Response?
        
    
        self.liveStreamApi!.createPrivate(name: name){(live, resp) in
            livestream = live
            response = resp
            self.deleteLiveStream(live: livestream!)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(livestream)
        XCTAssertNil(response)
        
    }
    
    //MARK:test Create Live Stream Error
    // player selected does not exist
    func testCreate_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let name = "title_test"
        let record = false
        let playerId = "pt3fePLEGw8xS6NF5x5A"
        var livestream: LiveStream?
        var response: Response?
        
        self.liveStreamApi!.create(name: name, record: record, playerId: playerId, isPublic: nil){(live, resp) in
            livestream = live
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(livestream)
        XCTAssertNotNil(response)
        
    }
    
    //MARK: test Get Live Stream By Id Success
    func testGetLiveById_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var liveStream: LiveStream?
        var response: Response?
        
        self.liveStreamApi!.create(name: "name"){(live, resp) in
            self.liveStreamApi!.getLiveStreamById(liveStreamId: (live?.liveStreamId)!){(live, resp) in
                liveStream = live
                response = resp
                self.deleteLiveStream(live: live)
                expectation.fulfill()
            }
        }

        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(liveStream)
        XCTAssertNil(response)
    }
    
    //MARK: test Get Live Stream By Id Error
    //wrong id
    func testGetLiveById_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li3ueibB0OSdA0JUTU"
        var liveStream: LiveStream?
        var response: Response?
        
        self.liveStreamApi!.getLiveStreamById(liveStreamId: liveStreamId){(live, resp) in
            liveStream = live
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(liveStream)
        XCTAssertNotNil(response)
    }
    
    
    //MARK: test Get All Live Stream Success
    func testGetAllLives_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var liveStreams: [LiveStream]?
        var response: Response?
        
        self.liveStreamApi!.create(name: "name"){(live, resp) in
            self.liveStreamApi!.getAllLiveStreams(){(lives, resp) in
                liveStreams = lives
                response = resp
                self.deleteLiveStream(live: live)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(liveStreams)
        XCTAssertNil(response)
        XCTAssertTrue(liveStreams!.count >= 0, "the list must be greater than 0 and must not be null")
        
    }
    
    //MARK: test Update Live Stream Success
    func testUpdateLiveStream_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        
        self.createPlayer { p in
            self.liveStreamApi!.create(name: "live", playerId: p.playerId!){(live, resp) in

                self.liveStreamApi!.updateLiveStream(liveId: (live?.liveStreamId)!, name: "new name", record: true, playerId: p.playerId){(data,resp2) in
                    self.deleteLiveStream(live: live)
                    self.deletePlayer(player: p)
                    response = resp2
                    isUpdated = data
                    expectation.fulfill()
                }
            }
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: test Update Live Stream Error
    func testUpdateLiveStream_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        
        self.createPlayer { p in
            self.liveStreamApi!.create(name: "live", playerId: p.playerId!){(live, resp) in

                self.liveStreamApi!.updateLiveStream(liveId: (live?.liveStreamId)!, name: "new name", record: true, playerId: "doesntexist"){(data,resp2) in
                    self.deleteLiveStream(live: live)
                    self.deletePlayer(player: p)
                    response = resp2
                    isUpdated = data
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUpdated)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Update Live Stream Success
    func testUpdateLiveStream_record_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        
        self.liveStreamApi!.create(name: "live"){(live, resp) in

            self.liveStreamApi!.updateLiveStream(liveId: (live?.liveStreamId)!, record: false){(data,resp2) in
                self.deleteLiveStream(live: live)
                response = resp2
                isUpdated = data
                expectation.fulfill()
            }
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: test Update Live Stream Error
    func testUpdateLiveStream_record_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        let liveStreamId = "li3ueibB0OSdA0JUTUzWbU"
        
        self.liveStreamApi!.updateLiveStream(liveId: liveStreamId,record : false){(data,resp) in
            expectation.fulfill()
            isUpdated = data
            response = resp
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUpdated)
        XCTAssertNotNil(response)
    }
    
    
    //MARK: test Delete Live Stream Success
    func testDeleteLiveStream_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "liWl49txMbBMJCJBTAXuIyT"
        var isDeleted = false
        var response: Response?
        
        self.liveStreamApi!.create(name: "live"){(live, resp) in
            self.liveStreamApi!.deleteLiveStream(liveStreamId: (live?.liveStreamId)!){ (deleted, resp) in
                expectation.fulfill()
                isDeleted = deleted
                response = resp
            }
        }
    
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(isDeleted)
        XCTAssertNil(response)
    }
    
    //MARK: test Delete Live Stream Error
    func testDeleteLiveStream_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li7IPfB3w1XEzOISfzeq1j8n"
        var isDeleted = false
        var response: Response?
        
    
        self.liveStreamApi!.deleteLiveStream(liveStreamId: liveStreamId){ (deleted, resp) in
            expectation.fulfill()
            isDeleted = deleted
            response = resp
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertFalse(isDeleted)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Upload Thumbnail Live Stream Success
    func testUploadThumbnail_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let filename = "foret.jpg"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "shopping-basket", ofType: "png")!
        let url = bundle.url(forResource: "shopping-basket", withExtension: "png")!
        let testImage = UIImage(named: "shopping-basket", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imagedata = testImage?.pngData()
        var isUploaded = false
        var response: Response?
    
        self.liveStreamApi!.create(name: "live"){(live, resp) in
            self.liveStreamApi!.uploadImageThumbnail(liveStreamId: (live?.liveStreamId)!, url: url, filePath: filepath, fileName: filename, imageData: imagedata!){(uploaded, resp) in
                self.deleteLiveStream(live: live)
                isUploaded = uploaded
                response = resp
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUploaded)
        XCTAssertNil(response)
    }
    
    //MARK: test Upload Thumbnail Live Stream Error
    func testUploadThumbnail_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let liveStreamId = "li4tTuqrImXBVrYi8XH5Oz"
        let filename = "foret.jpg"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "shopping-basket", ofType: "png")!
        let url = bundle.url(forResource: "shopping-basket", withExtension: "png")!
        let testImage = UIImage(named: "shopping-basket", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imagedata = testImage?.pngData()
        var isUploaded = false
        var response: Response?
        
        self.liveStreamApi!.uploadImageThumbnail(liveStreamId: liveStreamId, url: url, filePath: filepath, fileName: filename, imageData: imagedata!){(uploaded, resp) in
            isUploaded = uploaded
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUploaded)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Delete Thumbnail Live Stream Success
    func testDeleteThumbnail_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false

        self.liveStreamApi!.create(name: "live"){(live, resp) in
            self.liveStreamApi!.deleteThumbnail(liveStreamId: (live?.liveStreamId)!){ (deleted, resp) in
                self.deleteLiveStream(live: live)
                response = resp
                isDeleted = deleted
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isDeleted)
        XCTAssertNil(response)
    }
    
    //MARK: test Delete Thumbnail Live Stream Error
    func testDeleteThumbnail_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        let liveStreamId = "li4tTuqrImXBVrYi8XH5OT"

        self.liveStreamApi!.deleteThumbnail(liveStreamId: liveStreamId){ (deleted, resp) in
            response = resp
            isDeleted = deleted
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isDeleted)
        XCTAssertNotNil(response)
    }
}
