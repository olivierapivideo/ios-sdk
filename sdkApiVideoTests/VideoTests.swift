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

class VideoTests: XCTestCase {
    let authClient = Client()
    
    //MARK: test upload stream video success
    func testStreamUploadSuccess(){
        let expectation = self.expectation(description: "request should succeed")
        var isAuthentified = false
        var isUploaded = false
        var response: Response?
        var videoApi: VideoApi!
        let filename = "tennis.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "tennis court", ofType: "mp4")!
        let url = bundle.url(forResource: "tennis court", withExtension: "mp4")
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            videoApi.create(title: filename, description: "desc", fileName: filename, filePath: filepath, url: url!){(uploaded, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }else{
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }
            }
        }else{
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(response)
    }
    //MARK: test init video success
    func testuploadLargeStream_Success(){
        let expectation = self.expectation(description: "request should succeed")
        var isAuthentified = false
        var isUploaded = false
        let videoUri = "/videos/vi1kY2TTlIvImPNWq9ZEPb27/source"
        var response: Response?
        var videoApi: VideoApi!
        let filename = "tennis.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "tennis court", ofType: "mp4")!
        let url = bundle.url(forResource: "tennis court", withExtension: "mp4")
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            videoApi.uploadLargeStream(videoUri: videoUri, fileName: filename, filePath: filepath, url: url!){(uploaded, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }else{
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }
            }
        }else{
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(response)
    }
    
    
    //MARK: test init video success
    func testInitVideo_success(){
        let expectation = self.expectation(description: "request should succeed")
        let title = "title_test"
        let description = "description_test"
        var isAuthentified = false
        var videoUri = ""
        var response: Response?
        var videoApi: VideoApi!
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            videoApi.initVideo(title: title, description: description){ (uri, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    videoUri = uri
                    response = resp
                }else{
                    expectation.fulfill()
                    videoUri = uri
                    response = resp
                }
            }
        }else{
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(videoUri != "")
        XCTAssertTrue(videoUri.count > 1)
        XCTAssertNil(response)
    }
    
    //MARK: test init video error
    // wrong access token
    func testInitVideo_error(){
        let expectation = self.expectation(description: "request should succeed")
        let title = "title_test"
        let description = "description_test"
        var isAuthentified = false
        var videoUri = ""
        var response: Response?
        var videoApi: VideoApi!

        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTV"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                response = resp
                print("authentified status => \((resp?.statusCode)!) : \((resp?.message)!)")
            }
        }
        
        if isAuthentified{
            videoApi.initVideo(title: title, description: description){ (uri, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    videoUri = uri
                    response = resp
                }else{
                    expectation.fulfill()
                    videoUri = uri
                    response = resp
                }
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
    func testUploadSmallVideo_success(){
        let expectation = self.expectation(description: "request should succeed")
        var isAuthentified = false
        var isUploaded = false
        var response: Response?
        var videoApi: VideoApi!
        let videoUri = "/videos/vi3doobviYa8f7r2HoptU2aG/source"
        let filename = "Watermelon.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "Watermelon.mp4", ofType: "mp4") ?? "/Users/romainpetit/Documents/GitHub/ios-sdk/sdkApiVideoTests/asset/Watermelon.mp4"
        let url = URL(fileURLWithPath: filepath)
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        
        if isAuthentified{
            videoApi.uploadSmallVideoFile(videoUri: videoUri, fileName: filename, filePath: filepath, url: url){ (uploaded, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }else{
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }
            }
        }else{
            expectation.fulfill()
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUploaded)
        XCTAssertNil(response)
        
    }
    
    //MARK: test Upload Small Video Error
    //wrong video uri
    func testUploadSmallVideo_error(){
        let expectation = self.expectation(description: "request should succeed")
        var isAuthentified = false
        var isUploaded = false
        var response: Response?
        var videoApi: VideoApi!
        let videoUri = "/videos/vi41UsGbyZ9WnUfeC6e/source"
        let filename = "lapin.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "video-test", ofType: "mp4")!
        let url = bundle.url(forResource: "video-test", withExtension: "mp4")
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            videoApi.uploadSmallVideoFile(videoUri: videoUri, fileName: filename, filePath: filepath, url: url!){ (uploaded, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }else{
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }
            }
        }else{
            expectation.fulfill()
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUploaded)
        XCTAssertNotNil(response)
        
    }

    
    //MARK: test Upload Big Video
    func testUploadBigVideo_success(){
        let expectation = self.expectation(description: "request should succeed")
        var isAuthentified = false
        var isUploaded = false
        var response: Response?
        var videoApi: VideoApi!
        let videoUri = "/videos/vi4TR6kBRQx7dnaCR7DcQtqX/source"
        _ = Bundle(for: type(of: self)).path(forResource: "rabit", ofType: "mp4")
        let filename = "rabit.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "2019_03_03_15_34_31", ofType: "mp4")!
        let url = bundle.url(forResource: "2019_03_03_15_34_31", withExtension: "mp4")!
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if isAuthentified{
            videoApi.uploadBigVideoFile(videoUri: videoUri, fileName: filename, filePath: filepath, url: url){ (uploaded, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }else{
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }
            }
        }else{
            expectation.fulfill()
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUploaded)
        XCTAssertNil(response)
    }
    
    //MARK: test Upload Big Video Error
    // wrong uri
    func testUploadBigVideo_error(){
        let expectation = self.expectation(description: "request should succeed")
        var isAuthentified = false
        var isUploaded = false
        var response: Response?
        var videoApi: VideoApi!
        let videoUri = "/videos/dhjefhizhfiu/source"
        _ = Bundle(for: type(of: self)).path(forResource: "rabit", ofType: "mp4")
        let filename = "rabit.mp4"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "2019_03_03_15_34_31", ofType: "mp4")!
        let url = bundle.url(forResource: "2019_03_03_15_34_31", withExtension: "mp4")!
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if isAuthentified{
            videoApi.uploadBigVideoFile(videoUri: videoUri, fileName: filename, filePath: filepath, url: url){ (uploaded, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }else{
                    expectation.fulfill()
                    isUploaded = uploaded
                    response = resp
                }
            }
        }else{
            expectation.fulfill()
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUploaded)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Create func Success
    func testCreate_success(){
        let expectation = self.expectation(description: "request should succeed")
        let title = "title_test_kart"
        let description = "description_test_kart"
        let filename = "kart.mov"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "IMG_2226", ofType: "MOV")!
        let url = bundle.url(forResource: "IMG_2226", withExtension: "MOV")!
        var isAuthentified = false
        var isCreated = false
        var response: Response?
        var videoApi: VideoApi!

        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if isAuthentified{
            videoApi.create(title: title, description: description, fileName: filename, filePath: filepath, url: url){ (created, resp) in
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
            expectation.fulfill()
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 10000, handler: nil)
        XCTAssertTrue(isCreated)
        XCTAssertNil(response)
    }
    
    //MARK: test Create func Error
    func testCreate_error(){
        let expectation = self.expectation(description: "request should succeed")
        let title = "title_test_kart"
        let description = "description_test_kart"
        let filename = "kart.mov"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "IMG_2226", ofType: "MOV")!
        let url = bundle.url(forResource: "IMG_2226", withExtension: "MOV")!
        var isAuthentified = false
        var isCreated = false
        var response: Response?
        var videoApi: VideoApi!

        self.authClient.createProduction(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, resp) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if isAuthentified{
            videoApi.create(title: title, description: description, fileName: filename, filePath: filepath, url: url){ (created, resp) in
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
            expectation.fulfill()
            print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
        }
        
        waitForExpectations(timeout: 10000, handler: nil)
        XCTAssertFalse(isCreated)
        XCTAssertNotNil(response)
    }
    
    
    //MARK: test Get video by id Success
    func testGetVideoById_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi4Iw8Xnuy2ATAsw2GVH7s9A"
        var isAuthentified = false
        var videoApi: VideoApi!
        var video: Video?
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi

            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.getVideoByID(videoId: videoId){ (vid, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    video = vid
                    response = resp
                }else{
                    expectation.fulfill()
                    video = vid
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(video)
        XCTAssertNil(response)
    }
    
    //MARK: test Get video by id Error
    //wrong id
    func testGetVideoById_error(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi7Qh3UlGKquTWctVi0C"
        var isAuthentified = false
        var videoApi: VideoApi!
        var video: Video?
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.getVideoByID(videoId: videoId){ (vid, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    video = vid
                    response = resp
                }else{
                    expectation.fulfill()
                    video = vid
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(video)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Get all videos Success
    func testGetAllVideos_success(){
        let expectation = self.expectation(description: "request should succeed")
        var myVideos: [Video]?
        var response: Response?
        var isAuthentified = false
        var videoApi: VideoApi!

        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            videoApi.getAllVideos(){(videos, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myVideos = videos
                    response = resp
                }else{
                    expectation.fulfill()
                    myVideos = videos
                    response = resp
                }
                
            }
        }
        print("nb videos : \(myVideos!.count)")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myVideos)
        XCTAssertNil(response)
        XCTAssertTrue(myVideos!.count >= 0, "the list must be greater than 0 and must not be null")
    }
    
    //MARK: test Get all videos Error
    func testGetAllVideos_Error(){
        let expectation = self.expectation(description: "request should succeed")
        var myVideos: [Video]?
        var response: Response?
        var isAuthentified = false
        var videoApi: VideoApi!

        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if isAuthentified{
            videoApi.getAllVideos(){(videos, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myVideos = videos
                    response = resp
                }else{
                    expectation.fulfill()
                    myVideos = videos
                    response = resp
                }
                
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myVideos)
        XCTAssertNotNil(response)
        XCTAssertTrue(myVideos!.count == 0, "the list must be equal to 0")
        
    }
    
    //MARK: test Delete Video Success
    func testDeleteVideo_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi7TcP4YXaOJTiRYuE1OGTb2"
        var isAuthentified = false
        var videoApi: VideoApi!
        var isDeleted = false
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            videoApi.deleteVideo(videoId: videoId){ (deleted, resp) in
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
    
    //MARK: test Update video info
    func testUpdateVideo_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi52DHXFPKhqlidqBkeMdk6a"
        var isAuthentified = false
        var videoApi: VideoApi!
        var isUpdated = false
        var response: Response?
        
        let video = Video(videoId: videoId, title: "video update", description: "video desc", isPublic: true, publishedAt: nil, tags: nil, metaData: nil, assets: nil, sourceVideo: nil, playerId: nil, panoramic: false)
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.updateVideo(video: video){(updated, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    isUpdated = updated
                    response = resp
                }else{
                    expectation.fulfill()
                    isUpdated = updated
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: test Delete Video Error
    func testDeleteVideo_error(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi41UsGbWnUfejKBQM"
        var isAuthentified = false
        var videoApi: VideoApi!
        var isDeleted = false
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.deleteVideo(videoId: videoId){ (deleted, resp) in
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
    
    //MARK: test Get Video Status Success
    func testGetStatus_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi5DjJ6QRAX0nYOZKxrlT6rS"
        var isAuthentified = false
        var videoApi: VideoApi!

        var status: Status?
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.getStatus(videoId: videoId){(stat, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                }else{
                    expectation.fulfill()
                    status = stat
                    response = resp
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(status)
        XCTAssertNil(response)
    }
    
    //MARK: test Get Video Status Error
    func testGetStatus_error(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi7Qh3UlGKquTRFXyi0C"
        var isAuthentified = false
        var videoApi: VideoApi!
        var status: Status?
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.getStatus(videoId: videoId){(stat, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                }else{
                    expectation.fulfill()
                    status = stat
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(status)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Pick Thumbnail Success
    func testPickThumbnail_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi5DjJ6QRAX0nYOZKxrlT6rS"
        var isAuthentified = false
        var videoApi: VideoApi!

        var isChanged = false
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.pickThumbnail(videoId: videoId, timecode: "00:01:36.00"){(changed, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                }else{
                    expectation.fulfill()
                    isChanged = changed
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isChanged)
        XCTAssertNil(response)
    }
    
    //MARK: test Pick Thumbnail Error
    func testPickThumbnail_error(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi5DjJ6QRAX0nYOZKxrlT6rS"
        var isAuthentified = false
        var videoApi: VideoApi!
        var isChanged = false
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.pickThumbnail(videoId: videoId, timecode: "00:01:00.00"){(changed, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                }else{
                    expectation.fulfill()
                    isChanged = changed
                    response = resp
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isChanged)
        XCTAssertNotNil(response)
    }
    
    //MARK: test Upload Image as Thumbnail Success
    func testUplaodImageThumbnail_success(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi2k0uesF8c6a730BnRDDRVG"
        var isAuthentified = false
        var videoApi: VideoApi!
        let filename = "foret.jpg"
        let bundle = Bundle(for: type(of: self))
        let filepath = bundle.path(forResource: "shopping-basket", ofType: "png")!
        let url = bundle.url(forResource: "shopping-basket", withExtension: "png")!
        let testImage = UIImage(named: "shopping-basket", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imagedata = testImage?.pngData()
        var isUploaded = false
        var response: Response?
        
        self.authClient.createSandbox(key: "Gp75Z8pDZgx7aJdH2UeecrKMTeHJEvPMGAfi6rUTVkD"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.uploadImageThumbnail(videoId: videoId, url: url, filePath: filepath, fileName: filename, imageData: imagedata!){(uploaded, resp) in
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
    
    //MARK: test Upload Image as Thumbnail Error
    func testUplaodImageThumbnail_error(){
        let expectation = self.expectation(description: "request should succeed")
        let videoId = "vi7Qh3UlGKquVRFXyi0C"
        var isAuthentified = false
        var videoApi: VideoApi!
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
                videoApi = self.authClient.videoApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            videoApi.uploadImageThumbnail(videoId: videoId, url: url, filePath: filepath, fileName: filename, imageData: imagedata!){(uploaded, resp) in
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
    
}
