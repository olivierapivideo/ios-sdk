//
//  CaptionTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 27/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class CaptionTests: Common {
    var captionApi: CaptionApi?
    
    override func setUp() {
        super.setUp()
        self.captionApi = self.authClient.captionApi
    }

    //MARK: Upload caption
    func testUploadCaption_success() throws {
        try XCTSkipIf(getApiKey() == nil)        
        let expectation = self.expectation(description: "request should succeed")
        var isUploaded = false
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.createVideo() { (v) in
            self.captionApi!.upload(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "en"){ (uploaded, resp) in
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
    
    //MARK: get caption by id
    func testgetCaptionById_success() throws {
        try XCTSkipIf(getApiKey() == nil)        
        let expectation = self.expectation(description: "request should succeed")
        var caption: Caption?
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.createVideo() { (v) in
            self.captionApi!.upload(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "en"){ (uploaded, resp) in
                self.captionApi!.getCaption(videoId: v.videoId!, language: "en"){ (cap, resp2) in
                    caption = cap
                    response = resp2
                    self.deleteVideo(video: v)
                    expectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(caption)
        XCTAssertNil(response)
    }
    
    //MARK: get all captions
    func testGetAllCaption() throws {
        try XCTSkipIf(getApiKey() == nil)        
        let expectation = self.expectation(description: "request should succeed")
        var myCaptions: [Caption]?
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        
        self.createVideo() { (v) in
            self.captionApi!.upload(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "en"){ (uploaded, resp) in
                self.captionApi!.getAllCaptions(videoId: v.videoId!){(captions, resp2) in
                    myCaptions = captions
                    response = resp2
                    self.deleteVideo(video: v)
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        print("nb captions : \(myCaptions!.count)")
        XCTAssertNotNil(myCaptions)
        XCTAssertNil(response)
        XCTAssertTrue(myCaptions!.count >= 0, "the list must be greater than 0 and must not be null")
    }
    
    //MARK: Update default caption
    func testUpdateDefaultCaption() throws {
        try XCTSkipIf(getApiKey() == nil)        
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.createVideo() { (v) in
            self.captionApi!.upload(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "en"){ (uploaded, resp) in
                self.captionApi!.updateDefaultValue(videoId: v.videoId!, language: "en", isDefault: false){ (updated, resp) in
                    response = resp
                    isUpdated = updated
                    self.deleteVideo(video: v)
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: delete caption
    func testDeleteCaption() throws {
        try XCTSkipIf(getApiKey() == nil)        
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.createVideo() { (v) in
            self.captionApi!.upload(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "en"){ (uploaded, resp) in
                self.captionApi!.deleteCaption(videoId: v.videoId!, language: "en"){ (deleted, resp) in
                    response = resp
                    isDeleted = deleted
                    self.deleteVideo(video: v)
                    expectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isDeleted)
        print("response : \(String(describing: response))")
        XCTAssertNil(response)
    }
}
