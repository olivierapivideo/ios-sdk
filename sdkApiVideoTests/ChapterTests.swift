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
    //MARK: upload chapter
    func testUploadChapter_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi5ii0oM3z2BsBokyMWfRtFw"
        var isAuthentified = false
        var chapterApi: ChapterApi!
        var isUploaded = false
        var response: Response?
        let filename = "costarica_chapter_fr.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "costarica_chapter_fr", ofType: "vtt")!
        let url = bundle.url(forResource: "costarica_chapter_fr", withExtension: "vtt")!
        
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
        print("response : \(String(describing: response))")
        XCTAssertNil(response)
    }
    //MARK: get chapter by id
    func testgetChapterById_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi5ii0oM3z2BsBokyMWfRtFw"
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
    //MARK: get all chapters
    func testGetAllChapter(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi5ii0oM3z2BsBokyMWfRtFw"
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
    //MARK: delete chapter
    func testDeleteChapter(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let videoId = "vi5ii0oM3z2BsBokyMWfRtFw"
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
        XCTAssertTrue(isDeleted)
        print("response : \(String(describing: response))")
        XCTAssertNil(response)
    }

}
