//
//  VideoTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 20/12/2019.
//  Copyright © 2019 Romain. All rights reserved.
//
import Foundation
import XCTest
@testable import sdkApiVideo

class VideoTests: Common {
    var videoApi: VideoApi?
    
    override func setUp() {
        super.setUp()
        self.videoApi = self.authClient.videoApi
    }
    
    //MARK: test upload stream video success
    func testStreamUploadSuccess() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var finalVideo: Video?
        let filename = "574k.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "574k", ofType: "mp4")!
        let url = bundle.url(forResource: "574k", withExtension: "mp4")
        
        self.videoApi!.create(title: filename, description: "desc", fileName: filename, filePath: filepath, url: url!){(video, resp) in
            finalVideo = video
            response = resp
            
            if(finalVideo?.videoId != nil) {
                //   self.deleteVideo(video: finalVideo)
                expectation.fulfill()
            }
        }
     
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(finalVideo)
        XCTAssertEqual(finalVideo?.title, filename);
        XCTAssertNil(response)
    }
    
    //MARK: test init video success
    func testuploadLargeStream_Success() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var finalVideo: Video?
        let filename = "574k.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "574k", ofType: "mp4")!
        let url = bundle.url(forResource: "574k", withExtension: "mp4")
        
        self.videoApi!.setChunkSize(size: 1024*500); // 500kb chunks to simulate big file upload
        
        self.createVideo() { (video) in
            self.videoApi!.uploadLargeStream(videoUri: (video.sourceVideo?.uri)!, fileName: filename, filePath: filepath, url: url!){(video, resp) in
                finalVideo = video
                response = resp
                
                if(finalVideo?.videoId != nil) {
                    self.videoApi!.deleteVideo(videoId: (finalVideo?.videoId!)!) { success, response in
                        self.deleteVideo(video: video)
                        expectation.fulfill()
                    }
                }
            }
        }
            
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(finalVideo)
        XCTAssertEqual(finalVideo?.title, "test");
        XCTAssertNil(response)
    }
    
    //MARK: test init video error
    // wrong access token
    func testInitVideo_error() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        let title = "title_test"
        let description = "description_test"
        var isAuthentified = false
        var videoUri = ""
        var response: Response?
        var videoApi: VideoApi!

        self.authClient.createSandbox(key: "132"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                response = resp
                print("authentified status => \((resp?.statusCode)!) : \((resp?.message)!)")
            }
        }
        
        if isAuthentified{
            videoApi.initVideo(title: title, description: description){ (video, resp) in
                expectation.fulfill()
                videoUri = (video?.sourceVideo?.uri)!
                response = resp
            }
        }else{
            expectation.fulfill()
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(videoUri != "")
        XCTAssertFalse(videoUri.count > 1)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Upload Small Video Success
    func testUploadSmallVideo_success() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var finalVideo: Video?
        let filename = "574k.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "574k", ofType: "mp4")!
        let url = URL(fileURLWithPath: filepath)
        
        
        self.videoApi!.initVideo(title: filename, description: "") { v, res0 in
            self.videoApi!.uploadSmallVideoFile(videoUri: (v?.sourceVideo?.uri)!, fileName: filename, filePath: filepath, url: url){ (video, res1) in
                finalVideo = video
                response = res1
                
                self.videoApi!.deleteVideo(videoId: (finalVideo?.videoId)!) { success, res2 in
                    expectation.fulfill()
                }
            }
        }
    
        
        waitForExpectations(timeout: 100000, handler: nil)
        XCTAssertNotNil(finalVideo)
        XCTAssertNil(response)
        
    }
    
    //MARK: test Upload Small Video Error
    //wrong video uri
    func testUploadSmallVideo_error() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should not succeed")
        var response: Response?
        var finalVideo: Video?
        let videoUri = "/videos/thatdoesntexist/source"
        let filename = "574k.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "574k", ofType: "mp4")!
        let url = bundle.url(forResource: "574k", withExtension: "mp4")
        
        self.videoApi!.uploadSmallVideoFile(videoUri: videoUri, fileName: filename, filePath: filepath, url: url!){ (video, resp) in
                expectation.fulfill()
                finalVideo = video
                response = resp
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(finalVideo)
        XCTAssertNotNil(response)
    }

    
    
    //MARK: test Create func Success
    func testCreate_success() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        let title = "title_test"
        let description = "description_test"
        let filename = "574k.mp4"
        var finalVideo: Video?
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "574k", ofType: "mp4")!
        let url = bundle.url(forResource: "574k", withExtension: "mp4")!
        var response: Response?
        
        self.videoApi!.setChunkSize(size: 1024*500); // 500kb chunks to simulate big file upload

        self.videoApi!.create(title: title, description: description, fileName: filename, filePath: filepath, url: url){ (video, resp) in
            finalVideo = video
            response = resp
            self.videoApi!.deleteVideo(videoId: (video?.videoId)!) { success, res2 in
                expectation.fulfill()
            }
        }
    
        
        waitForExpectations(timeout: 100000, handler: nil)
        XCTAssertNotNil(finalVideo)
        XCTAssertNil(response)
    }
    
    //MARK: test Create func Error
    func testCreate_error() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        let description = "description_test_kart"
        let filename = "574k.mp4"
        var finalVideo: Video?
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "574k", ofType: "mp4")!
        let url = bundle.url(forResource: "574k", withExtension: "mp4")!
        var response: Response?

        self.videoApi!.create(title: "", description: description, fileName: filename, filePath: filepath, url: url){ (video, resp) in
            expectation.fulfill()
            finalVideo = video
            response = resp
        }
        
        waitForExpectations(timeout: 10000, handler: nil)
        XCTAssertNil(finalVideo)
        XCTAssertNotNil(response)
    }
    
    
    //MARK: test Get video by id Success
    func testGetVideoById_success() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        var video: Video?
        var response: Response?
        
        self.createVideo() { (v) in
            self.videoApi!.getVideoByID(videoId: v.videoId!){ (vid, resp) in
                video = vid
                response = resp
                self.deleteVideo(video: video)
                expectation.fulfill()
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(video)
        XCTAssertNil(response)
    }
    
    //MARK: test Get video by id Error
    //wrong id
    func testGetVideoById_error() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "doesnetexist"
        var video: Video?
        var response: Response?
        
        self.videoApi!.getVideoByID(videoId: videoId){ (vid, resp) in
                expectation.fulfill()
                video = vid
                response = resp
        }

        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(video)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Get all videos Success
    func testGetAllVideos_success() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        var myVideos: [Video]?
        var response: Response?

        self.videoApi!.getAllVideos(){(videos, resp) in
            expectation.fulfill()
            myVideos = videos
            response = resp
        }
    
        print("nb videos : \(myVideos!.count)")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myVideos)
        XCTAssertNil(response)
        XCTAssertTrue(myVideos!.count >= 0, "the list must be greater than 0 and must not be null")
    }
    
    //MARK: test Update video info
    func testUpdateVideo_success() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        var isUpdated = false
        var response: Response?
        
        self.createVideo() { (v) in
            let video = Video(videoId: v.videoId!, title: "video update", description: "video desc", isPublic: true, publishedAt: nil, tags: nil, metaData: nil, assets: nil, sourceVideo: nil, playerId: nil, panoramic: false)
            
            self.videoApi!.updateVideo(video: video){(updated, resp) in
                isUpdated = updated
                response = resp
                self.deleteVideo(video: v)
                expectation.fulfill()
            }
        }
    
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: test Delete Video Error
    func testDeleteVideo_error() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "doesntexist"
        var isDeleted = false
        var response: Response?
        
        self.videoApi!.deleteVideo(videoId: videoId){ (deleted, resp) in
                expectation.fulfill()
                isDeleted = deleted
                response = resp
        }
    
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertFalse(isDeleted)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Get Video Status Success
    func testGetStatus_success() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var status: Status?
        var finalVideo: Video?
        let filename = "574k.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "574k", ofType: "mp4")!
        let url = bundle.url(forResource: "574k", withExtension: "mp4")
        
        self.videoApi!.create(title: filename, description: "desc", fileName: filename, filePath: filepath, url: url!) { (video, resp) in
            self.videoApi!.getStatus(videoId: (video?.videoId!)!) { (stat, resp) in
                status = stat
                response = resp
                self.deleteVideo(video: video)
                expectation.fulfill()
            }
        }
    
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(status)
        XCTAssertNil(response)
    }
    
    //MARK: test Get Video Status Error
    func testGetStatus_error() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "doesntexist"
        var status: Status?
        var response: Response?
        
        self.videoApi!.getStatus(videoId: videoId){(stat, resp) in
            expectation.fulfill()
            status = stat
            response = resp
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(status)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Pick Thumbnail Success
    func testPickThumbnail_success() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should succeed")

        var isChanged = false
        var response: Response?
        
        self.createVideo() { (v) in
            self.videoApi!.pickThumbnail(videoId: v.videoId!, timecode: "00:00:5.00"){(changed, resp) in
                isChanged = changed
                response = resp
                self.deleteVideo(video: v)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isChanged)
        XCTAssertNil(response)
    }
    
    //MARK: test Pick Thumbnail Error
    func testPickThumbnail_error() throws {
        try XCTSkipIf(getApiKey() == nil)
        
        let expectation = self.expectation(description: "request should not succeed")
        var isChanged = false
        var response: Response?
        
        self.videoApi!.pickThumbnail(videoId: "doesntexist", timecode: "77:01:00.00"){(changed, resp) in
            expectation.fulfill()
            isChanged = changed
            response = resp
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isChanged)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Upload Image as Thumbnail Success
    func testUplaodImageThumbnail_success() throws {
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
        
        self.createVideo() { (v) in
            self.videoApi!.uploadImageThumbnail(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, imageData: imagedata!){(uploaded, resp) in
                isUploaded = uploaded
                response = resp
                self.deleteVideo(video: v)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUploaded)
        print("response : \(String(describing: response))")
        XCTAssertNil(response)
    }
    
    //MARK: test Upload Image as Thumbnail Error
    func testUplaodImageThumbnail_error() throws {
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
  
        self.videoApi!.uploadImageThumbnail(videoId: "doesntexist", url: url, filePath: filepath, fileName: filename, imageData: imagedata!){(uploaded, resp) in
            isUploaded = uploaded
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUploaded)
        XCTAssertNotNil(response)
    }
    
}
