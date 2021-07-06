//
//  ChapterTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 28/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class ChapterTests: Common {
    var chapterApi: ChapterApi?
    
    override func setUp() {
        super.setUp()
        self.chapterApi = self.authClient.chapterApi
    }
    
    //MARK: upload chapter
    func testUploadChapter_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var isUploaded = false
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
    
        self.createVideo() { (v) in
            self.chapterApi!.uploadChapter(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "fr"){ (uploaded, resp) in
                isUploaded = uploaded
                response = resp
                self.deleteVideo(video: v)
                expectation.fulfill()
            }
        }
        
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUploaded)
        XCTAssertNil(response)
    }
    
    //MARK: upload chapter error
    func testUploadChapter_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi4TR6kBRQx7dnaCR7DcQ"
        var isUploaded = false
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.chapterApi!.uploadChapter(videoId: videoId, url: url, filePath: filepath, fileName: filename, language: "fr"){ (uploaded, resp) in
            isUploaded = uploaded
            response = resp
            expectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUploaded)
        XCTAssertNotNil(response)
    }
    
    //MARK: get chapter by id
    func testgetChapterById_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var chapter: Chapter?
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.createVideo() { (v) in
            self.chapterApi!.uploadChapter(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "fr"){ (uploaded, resp) in
                self.chapterApi!.getChapter(videoId: v.videoId!, language: "fr"){ (chap, resp2) in
                    chapter = chap
                    response = resp2
                    self.deleteVideo(video: v)
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(chapter)
        XCTAssertNil(response)
    }
    
    //MARK: get chapter by id
    func testgetChapterById_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi4TR6kBRQx7dnaCR7DcQtqX"
        var chapter: Chapter?
        var response: Response?
        
        
        self.chapterApi!.getChapter(videoId: videoId, language: "en"){ (chap, resp) in
            chapter = chap
            response = resp
            expectation.fulfill()
        }

        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(chapter)
        XCTAssertNotNil(response)
    }
    
    //MARK: get all chapters success
    func testGetAllChapter_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var myChapters: [Chapter]?
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.createVideo() { (v) in
            self.chapterApi!.uploadChapter(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "fr"){ (uploaded, resp) in
                self.chapterApi!.getAllChapters(videoId: v.videoId!){(chapters, resp2) in
                    myChapters = chapters
                    response = resp2
                    self.deleteVideo(video: v)
                    expectation.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        print("nb chapters : \(myChapters!.count)")
        XCTAssertNotNil(myChapters)
        XCTAssertNil(response)
        XCTAssertTrue(myChapters!.count >= 0, "the list must be greater than 0 and must not be null")
    }
    
    //MARK: get all chapters Error
    func testGetAllChapter_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should not succeed")
        let videoId = "vi5bk2odFpB18LY3G62y8Ly"
        var myChapters: [Chapter]?
        var response: Response?
        
        
        self.chapterApi!.getAllChapters(videoId: videoId){(chapters, resp) in
            myChapters = chapters
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(response)
        XCTAssertTrue(myChapters!.count == 0, "the list must be equal to 0 and must not be null")
    }
    
    //MARK: delete chapter Success
    func testDeleteChapter_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!

        
        self.createVideo() { (v) in
            self.chapterApi!.uploadChapter(videoId: v.videoId!, url: url, filePath: filepath, fileName: filename, language: "fr"){ (uploaded, resp) in
                self.chapterApi!.deleteChapter(videoId: v.videoId!, language: "fr"){ (deleted, resp) in
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
    
    //MARK: delete chapter Error
    func testDeleteChapter_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should not succeed")
        var response: Response?
        var isDeleted = false
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        
        self.chapterApi!.deleteChapter(videoId: videoId, language: "en"){ (deleted, resp) in
            response = resp
            isDeleted = deleted
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isDeleted)
        XCTAssertNotNil(response)
    }

}
