//
//  CaptionTests.swift
//  sdkApiVideoTests
//
//  Created by romain PETIT on 27/01/2020.
//  Copyright © 2020 Romain. All rights reserved.
//

import XCTest
@testable import sdkApiVideo

class CaptionTests: XCTestCase {
    let authClient = Client()

    //MARK: Upload caption
    func testUploadCaption_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var isAuthentified = false
        var captionApi: CaptionApi!
        var isUploaded = false
        var response: Response?
        let filename = "my_captions.vtt"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "my_captions", ofType: "vtt")!
        let url = bundle.url(forResource: "my_captions", withExtension: "vtt")!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                captionApi = self.authClient.captionApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            captionApi.upload(videoId: videoId, url: url, filePath: filepath, fileName: filename, language: "en"){ (uploaded, resp) in
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
    
    //MARK: get caption by id
    func testgetCaptionById_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var isAuthentified = false
        var captionApi: CaptionApi!
        var caption: Caption?
        var response: Response?
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                captionApi = self.authClient.captionApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            captionApi.getCaption(videoId: videoId, language: "en"){ (cap, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    caption = cap
                    response = resp
                }else{
                    expectation.fulfill()
                    caption = cap
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(caption)
        XCTAssertNil(response)
    }
    
    //MARK: get all captions
    func testGetAllCaption(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var myCaptions: [Caption]?
        var response: Response?
        var isAuthentified = false
        var captionApi: CaptionApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                captionApi = self.authClient.captionApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            captionApi.getAllCaptions(videoId: videoId){(captions, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myCaptions = captions
                    response = resp
                }else{
                    expectation.fulfill()
                    myCaptions = captions
                    response = resp
                }
                
            }
        }
        print("nb captions : \(myCaptions!.count)")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myCaptions)
        XCTAssertNil(response)
        XCTAssertTrue(myCaptions!.count >= 0, "the list must be greater than 0 and must not be null")
    }
    
    //MARK: Update default caption
    func testUpdateDefaultCaption(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var isUpdated = false
        var isAuthentified = false
        var captionApi: CaptionApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                captionApi = self.authClient.captionApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            captionApi.updateDefaultValue(videoId: videoId, language: "en", isDefault: false){ (updated, resp) in
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
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: delete caption
    func testDeleteCaption(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let videoId = "vi58NQXuw3x8Q90gehtSCdue"
        var captionApi: CaptionApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                captionApi = self.authClient.captionApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            captionApi.deleteCaption(videoId: videoId, language: "en"){ (deleted, resp) in
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
