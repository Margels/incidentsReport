//
//  motorolaCodingChallengeUITests.swift
//  motorolaCodingChallengeUITests
//
//  Created by Martina on 14/07/22.
//

import XCTest


class motorolaCodingChallengeUITests: XCTestCase {

    override func setUpWithError() throws {
        
        continueAfterFailure = false
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRearrangeButton() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        let id = app.tables.cells.element(boundBy: 15).identifier
        let id2 = app.tables.cells.element(boundBy: 14).identifier
        let id3 = app.tables.cells.element(boundBy: 13).identifier
        app.navigationBars.buttons.firstMatch.tap()
        
        XCTAssertEqual(app.tables.cells.element(boundBy: 0).identifier, id)
        XCTAssertEqual(app.tables.cells.element(boundBy: 1).identifier, id2)
        XCTAssertEqual(app.tables.cells.element(boundBy: 2).identifier, id3)
    }
    
    func testLoadDataAPI() {
        
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertEqual(app.tables.cells.count, 16)
        
        app.navigationBars.buttons.firstMatch.tap()
        
        XCTAssertEqual(app.tables.cells.count, 16)
        
    }
    
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
