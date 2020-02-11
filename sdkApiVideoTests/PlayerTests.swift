//
//  sdkApiVideoTests.swift
//  sdkApiVideoTests
//
//  Created by Romain on 30/09/2019.
//  Copyright © 2019 Romain. All rights reserved.
//
import Foundation
import XCTest
@testable import sdkApiVideo

class PlayerTests: XCTestCase {
    let authClient = Client()
    
    let player_success = Player(playerId: "1", shapeMargin: 10, shapeRadius: 3, shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rgba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: false, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "fr", createdAt: "", updatedAt: "")
    
    let player_error = Player(playerId: "1", shapeMargin: 10, shapeRadius: 3, shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: false, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "fr", createdAt: "", updatedAt: "")
    
    let player_updated_success = Player(playerId: "pt3fePLEGw8xS6NF5x5AyuVB", shapeMargin: 3, shapeRadius: 10, shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rgba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: false, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "fr", createdAt: "", updatedAt: "")
    
    let player_updated_error = Player(playerId: "jiforz", shapeMargin: 3, shapeRadius: 10, shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rgba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: false, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "fr", createdAt: "", updatedAt: "")
    
    
    
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
    
    //MARK: test Create Player Success
    func testCreatePlayer_Success(){
        let expectation = self.expectation(description: "request should succeed")
        var isCreated = false
        var response: Response?
        var isAuthentified = false
        var playerApi: PlayerApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            playerApi.createPlayer(player: self.player_success){ (created, resp) in
                print("CREATED => \(created)")
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    response = resp
                    isCreated = created
                }else{
                    expectation.fulfill()
                    response = resp
                    isCreated = created
                }
            }
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isCreated)
        XCTAssertNil(response)
    }
    
    //MARK: test Create Player Error (wrong value)
    func testCreatePlayer_WrongPlayerValue(){
        let expectation = self.expectation(description: "request should not succeed")
        var isCreated = false
        var response: Response?
        var isAuthentified = false
        var playerApi: PlayerApi!

        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            playerApi.createPlayer(player: self.player_error){ (created, resp) in
                print("CREATED => \(created)")
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
        }
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isCreated)
        XCTAssertNotNil(response?.statusCode)
        XCTAssertNotNil(response?.message)
        XCTAssertNotNil(response?.url)
    }
    
    //MARK: test Get Players Success
    func testGetAllPlayers_Success(){
        let expectation = self.expectation(description: "request should succeed")
        var myPlayers: [Player]?
        var response: Response?
        var isAuthentified = false
        var playerApi: PlayerApi!

        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            playerApi.getAllPlayers(){(players, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myPlayers = players
                    response = resp
                }else{
                    expectation.fulfill()
                    myPlayers = players
                    response = resp
                }
            }
        }
        print("nb Players : \(myPlayers!.count)")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myPlayers)
        XCTAssertNil(response)
        XCTAssertTrue(myPlayers!.count >= 0, "the list must be greater than 0 and must not be null")
        
    }
    
    //MARK: test Get Players Error
    func testGetAllPlayers_WrongToken(){
        let expectation = self.expectation(description: "request should succeed")
        var myPlayers: [Player]?
        var response: Response?
        var isAuthentified = false
        var playerApi: PlayerApi!

        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            playerApi.getAllPlayers(){(players, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myPlayers = players
                    response = resp
                }else{
                    expectation.fulfill()
                    myPlayers = players
                    response = resp
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(myPlayers!.count == 0, "le tableau doit etre vide")
        XCTAssertNotNil(response?.statusCode)
        XCTAssertNotNil(response?.message)
        XCTAssertNotNil(response?.url)
    }
    
    //MARK: test Get Players By Id Success
    func testGetPlayerById_Success(){
        let expectation = self.expectation(description: "request should succeed")
        var myPlayer: Player?
        var response: Response?
        let playerId = "pt3fePLEGw8xS6NF5x5AyuVB"
        var isAuthentified = false
        var playerApi: PlayerApi!

        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            playerApi.getPlayerById(playerId: playerId){(player, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myPlayer = player
                    response = resp
                }else{
                    expectation.fulfill()
                    myPlayer = player
                    response = resp
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myPlayer)
        XCTAssertNil(response)
    }
    
    //MARK: test Get Players By Id Error
    func testGetPlayerById_WrongId(){
    // wrong id
        let expectation = self.expectation(description: "request should succeed")
        var myPlayer: Player?
        var response: Response?
        let playerId = "pl40idM2poDZnuHQjiodezXH0X8f8C"
        var isAuthentified = false
        var playerApi: PlayerApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if(isAuthentified){
            playerApi.getPlayerById(playerId: playerId){(player, resp) in
                if(resp != nil && resp?.statusCode != "200" && resp?.statusCode != "201" && resp?.statusCode != "202"){
                    expectation.fulfill()
                    myPlayer = player
                    response = resp
                }else{
                    expectation.fulfill()
                    myPlayer = player
                    response = resp
                }
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(myPlayer)
        XCTAssertNotNil(response)
        
    }
    
    //MARK: test Update Player Success
    func testUpdatePlayer_Success(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        var isAuthentified = false
        var playerApi: PlayerApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            playerApi.updatePlayer(player: self.player_updated_success){ (updated, resp) in
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
    
    //MARK: test Update Player Error (wrong id)
    func testUpdatePlayer_Error(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
        var isAuthentified = false
        var playerApi: PlayerApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            playerApi.updatePlayer(player: self.player_updated_error){ (updated, resp) in
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
        XCTAssertFalse(isUpdated)
        print("response : \(String(describing: response))")
        XCTAssertNotNil(response)
    }
    //MARK: Upload Logo
    func testUploadLogo_success(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUploaded = false
        var isAuthentified = false
        let playerId = "pt3fePLEGw8xS6NF5x5AyuVB"
        let url = URL(string: "https://google.com")
        var playerApi: PlayerApi!
        let path = Bundle(for: type(of: self)).path(forResource: "shopping-basket", ofType: "png")
        let testImage = UIImage(named: "shopping-basket", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imagedata = testImage?.pngData()
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi

            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            playerApi.uploadLogo(playerId: playerId, url: url!, filePath: path!, fileName: "shopping-basket.png", imageData: imagedata!){ (uploaded, resp) in
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
    //MARK: test Upload Logo Error image too big
    func testUploadLogo_error(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUploaded = false
        var isAuthentified = false
        let playerId = "pl66GVxFXe0iG80MsxuY8mJy"
        let url = URL(string: "https://google.com")
        var playerApi: PlayerApi!
        let path = Bundle(for: type(of: self)).path(forResource: "shopping-basket", ofType: "png")
        let testImage = UIImage(named: "shopping-basket", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imagedata = testImage?.pngData()
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        if(isAuthentified){
            playerApi.uploadLogo(playerId: playerId, url: url!, filePath: path!, fileName: "shopping-basket.png", imageData: imagedata!){ (uploaded, resp) in
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
        print("response : \(String(describing: response))")
        XCTAssertNotNil(response)
        
    }
    
    
    //MARK:test Delete Player Success
    func testDeletePlayer_success(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let playerId = "pt5QlLMHiQfIyurXXEDrrqf4"
        var playerApi: PlayerApi!
        
        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            playerApi.deletePlayer(playerId: playerId){ (deleted, resp) in
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
    
    //MARK:test Delete Player Error (wrong id)
    func testDeletePlayer_error(){
        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        var isAuthentified = false
        let playerId = "plV9hkYZaGJMJrAfN1IrHIOEZIODMG"
        var playerApi: PlayerApi!

        self.authClient.createSandbox(key: "USE_YOUR_SANDBOX_API_KEY"){ (authentified, response) in
            if authentified{
                isAuthentified = authentified
                playerApi = self.authClient.playerApi
            }else{
                print("authentified status => \((response?.statusCode)!) : \((response?.message)!)")
            }
        }
        
        if isAuthentified{
            playerApi.deletePlayer(playerId: playerId){ (deleted, resp) in
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
        print("response : \(String(describing: response))")
        XCTAssertNotNil(response)
    }

}
