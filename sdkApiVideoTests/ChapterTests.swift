//
//  ChapterTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 28/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class ChapterTests: XCTestCase {
    let authClient = Client()
    
    //MARK: upload chapter
    func testUploadChapter_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var isAuthentified = false
        var chapterApi: ChapterApi!
        var isUploaded = false
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                chapterApi = self.authClient.chapterApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            chapterApi.uploadChapter(videoId: videoId, url: url, filePath: filepath, fileName: filename, language: "fr"){ (uploaded, resp) in
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
    
    //MARK: upload chapter error
    func testUploadChapter_error(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi4TR6kBRQx7dnaCR7DcQ"
        var isAuthentified = false
        var chapterApi: ChapterApi!
        var isUploaded = false
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                chapterApi = self.authClient.chapterApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            chapterApi.uploadChapter(videoId: videoId, url: url, filePath: filepath, fileName: filename, language: "fr"){ (uploaded, resp) in
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
    
    //MARK: get chapter by id
    func testgetChapterById_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var isAuthentified = false
        var chapterApi: ChapterApi!
        var chapter: Chapter?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                chapterApi = self.authClient.chapterApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            chapterApi.getChapter(videoId: videoId, language: "fr"){ (chap, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    chapter = chap
                    response = resp
                }else{
                    expectation.fulfill()
                    chapter = chap
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(chapter)
        XCTAssertNil(response)
    }
    
    //MARK: get chapter by id
    func testgetChapterById_error(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi4TR6kBRQx7dnaCR7DcQtqX"
        var isAuthentified = false
        var chapterApi: ChapterApi!
        var chapter: Chapter?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                chapterApi = self.authClient.chapterApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            chapterApi.getChapter(videoId: videoId, language: "en"){ (chap, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    chapter = chap
                    response = resp
                }else{
                    expectation.fulfill()
                    chapter = chap
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(chapter)
        XCTAssertNotNil(response)
    }
    
    //MARK: get all chapters success
    func testGetAllChapter_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var myChapters: [Chapter]?
        var response: Response?
        var isAuthentified = false
        var chapterApi: ChapterApi!

        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                chapterApi = self.authClient.chapterApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            chapterApi.getAllChapters(videoId: videoId){(chapters, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myChapters = chapters
                    response = resp
                }else{
                    expectation.fulfill()
                    myChapters = chapters
                    response = resp
                }
                
            }
        }
        print("nb chapters : \(myChapters!.count)")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myChapters)
        XCTAssertNil(response)
        XCTAssertTrue(myChapters!.count >= 0, "the list must be greater than 0 and must not be null")
    }
    
    //MARK: get all chapters Error
    func testGetAllChapter_error(){
        let expectation = self.expectation(description: "request should not succeed")
        let videoId = "vi5bk2odFpB18LY3G62y8Ly"
        var myChapters: [Chapter]?
        var response: Response?
        var isAuthentified = false
        var chapterApi: ChapterApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                chapterApi = self.authClient.chapterApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            chapterApi.getAllChapters(videoId: videoId){(chapters, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myChapters = chapters
                    response = resp
                }else{
                    expectation.fulfill()
                    myChapters = chapters
                    response = resp
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(response)
        XCTAssertTrue(myChapters!.count == 0, "the list must be equal to 0 and must not be null")
    }
    
    //MARK: delete chapter Success
    func testDeleteChapter_success(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var chapterApi: ChapterApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                chapterApi = self.authClient.chapterApi

            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            chapterApi.deleteChapter(videoId: videoId, language: "fr"){ (deleted, resp) in
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
    
    //MARK: delete chapter Error
    func testDeleteChapter_error(){
        let expectation = self.expectation(description: "request should not succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var chapterApi: ChapterApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                chapterApi = self.authClient.chapterApi

            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            chapterApi.deleteChapter(videoId: videoId, language: "en"){ (deleted, resp) in
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
