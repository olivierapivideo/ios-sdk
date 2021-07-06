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

class PlayerTests: Common {
    var playerApi: PlayerApi?
    
    override func setUp() {
        super.setUp()
        self.playerApi = self.authClient.playerApi
    }
    
    
    public static let player_success = Player(playerId: "1", shapeMargin: 10, shapeRadius: 3, shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rgba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: false, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "fr", createdAt: "", updatedAt: "")
    
    let player_error = Player(playerId: "1", shapeMargin: 10, shapeRadius: 3, shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: false, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "fr", createdAt: "", updatedAt: "")
    
    let player_updated_success = Player(playerId: "pt7bXgxGybO8qgoddczYhxJt", shapeMargin: 3, shapeRadius: 10, shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rgba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: false, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "fr", createdAt: "", updatedAt: "")
    
    let player_updated_error = Player(playerId: "jiforz", shapeMargin: 3, shapeRadius: 10, shapeAspect: "flat", shapeBackgroundTop: "rgba(50, 50, 50, .7)", shapeBackgroundBottom: "rgba(50, 50, 50, .8)", text: "rgba(255, 255, 255, .95)", link: "rgba(255, 0, 0, .95)", linkHover: "rgba(255, 255, 255, .75)", linkActive: "rgba(255, 0, 0, .75)", trackPlayed: "rgba(255, 255, 255, .95)", trackUnplayed: "rgba(255, 255, 255, .1)", trackBackground: "rgba(0, 0, 0, 0)", backgroundTop: "rgba(72, 4, 45, 1)", backgroundBottom: "rgba(94, 95, 89, 1)", backgroundText: "rgba(255, 255, 255, .95)", enableApi: false, enableControls: false, forceAutoplay: true, hideTitle: true, forceLoop: false, assets: nil, language: "fr", createdAt: "", updatedAt: "")
    
    //MARK: test Create Player Success
    func testCreatePlayer_Success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var player: Player?
        var response: Response?
        
        self.playerApi!.createPlayer(player: PlayerTests.player_success){ (p, resp) in
            print("CREATED => \(p?.playerId)")
            response = resp
            player = p
            self.deletePlayer(player: player)
            expectation.fulfill()
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(player)
        XCTAssertNil(response)
    }
    
    //MARK: test Create Player Error (wrong value)
    func testCreatePlayer_WrongPlayerValue() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should not succeed")
        var player: Player?
        var response: Response?
        
        self.playerApi!.createPlayer(player: self.player_error){ (p, resp) in
            print("CREATED => \(p?.playerId)")
            player = p
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(player)
        XCTAssertNotNil(response?.statusCode)
        XCTAssertNotNil(response?.message)
        XCTAssertNotNil(response?.url)
    }
    
    //MARK: test Get Players Success
    func testGetAllPlayers_Success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var myPlayers: [Player]?
        var response: Response?
        
        self.playerApi!.getAllPlayers(){(players, resp) in
            myPlayers = players
            response = resp
            expectation.fulfill()
        }
        
        print("nb Players : \(myPlayers!.count)")
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myPlayers)
        XCTAssertNil(response)
        XCTAssertTrue(myPlayers!.count >= 0, "the list must be greater than 0 and must not be null")
        
    }
    
    
    //MARK: test Get Players By Id Success
    func testGetPlayerById_Success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var myPlayer: Player?
        var response: Response?
        
        self.createPlayer(){ (p) in
            self.playerApi!.getPlayerById(playerId: (p.playerId)!){(player, resp) in
                myPlayer = player
                response = resp
                self.deletePlayer(player: player)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNotNil(myPlayer)
        XCTAssertNil(response)
    }
    
    //MARK: test Get Players By Id Error
    func testGetPlayerById_WrongId() throws {
        try XCTSkipIf(getApiKey() == nil)

    // wrong id
        let expectation = self.expectation(description: "request should succeed")
        var myPlayer: Player?
        var response: Response?
        let playerId = "pl40idM2poDZnuHQjiodezXH0X8f8C"
        
        self.playerApi!.getPlayerById(playerId: playerId){(player, resp) in
            myPlayer = player
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertNil(myPlayer)
        XCTAssertNotNil(response)
        
    }
    
    //MARK: test Update Player Success
    func testUpdatePlayer_Success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false
    
        self.createPlayer(){ (p) in
            var update_payload = self.player_updated_success;
            update_payload.playerId = p.playerId
            self.playerApi!.updatePlayer(player: update_payload){ (updated, resp) in
                response = resp
                isUpdated = updated
                self.deletePlayer(player: p)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUpdated)
        XCTAssertNil(response)
    }
    
    //MARK: test Update Player Error (wrong id)
    func testUpdatePlayer_Error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUpdated = false

        self.playerApi!.updatePlayer(player: self.player_updated_error){ (updated, resp) in
            response = resp
            isUpdated = updated
            expectation.fulfill()
        }
    
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUpdated)
        print("response : \(String(describing: response))")
        XCTAssertNotNil(response)
    }
    
    //MARK: Upload Logo
    func testUploadLogo_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUploaded = false
        let url = URL(string: "https://google.com")
        let path = Bundle(for: type(of: self)).path(forResource: "shopping-basket", ofType: "png")
        let testImage = UIImage(named: "shopping-basket", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imagedata = testImage?.pngData()
        
        
        self.createPlayer(){ (p) in
            self.playerApi!.uploadLogo(playerId: (p.playerId)!, url: url!, filePath: path!, fileName: "shopping-basket.png", imageData: imagedata!){ (uploaded, resp) in
                isUploaded = uploaded
                response = resp
                self.deletePlayer(player: p)
                expectation.fulfill()
            }
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isUploaded)
        print("response : \(String(describing: response))")
        XCTAssertNil(response)
    }
    
    //MARK: test Upload Logo Error image too big
    func testUploadLogo_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isUploaded = false
        let playerId = "pl66GVxFXe0iG80MsxuY8mJy"
        let url = URL(string: "https://google.com")
        let path = Bundle(for: type(of: self)).path(forResource: "shopping-basket", ofType: "png")
        let testImage = UIImage(named: "shopping-basket", in: Bundle(for: type(of: self)), compatibleWith: nil)
        let imagedata = testImage?.pngData()

        self.playerApi!.uploadLogo(playerId: playerId, url: url!, filePath: path!, fileName: "shopping-basket.png", imageData: imagedata!){ (uploaded, resp) in
            isUploaded = uploaded
            response = resp
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isUploaded)
        print("response : \(String(describing: response))")
        XCTAssertNotNil(response)
        
    }
    
    
    //MARK:test Delete Player Success
    func testDeletePlayer_success() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
    
        
        self.createPlayer(){ (p) in
            self.playerApi!.deletePlayer(playerId: (p.playerId)!){ (deleted, resp) in
                response = resp
                isDeleted = deleted
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertTrue(isDeleted)
        print("response : \(String(describing: response))")
        XCTAssertNil(response)
    }
    
    //MARK:test Delete Player Error (wrong id)
    func testDeletePlayer_error() throws {
        try XCTSkipIf(getApiKey() == nil)

        let expectation = self.expectation(description: "request should succeed")
        var response: Response?
        var isDeleted = false
        let playerId = "plV9hkYZaGJMJrAfN1IrHIOEZIODMG"
        
        self.playerApi!.deletePlayer(playerId: playerId){ (deleted, resp) in
            response = resp
            isDeleted = deleted
            expectation.fulfill()
        }
    
        waitForExpectations(timeout: 100, handler: nil)
        XCTAssertFalse(isDeleted)
        print("response : \(String(describing: response))")
        XCTAssertNotNil(response)
    }

}
