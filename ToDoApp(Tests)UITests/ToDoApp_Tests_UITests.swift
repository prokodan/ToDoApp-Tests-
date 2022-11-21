//
//  ToDoApp_Tests_UITests.swift
//  ToDoApp(Tests)UITests
//
//  Created by Данил Прокопенко on 11.11.2022.
//

import XCTest

final class ToDoApp_Tests_UITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
       
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--UITesting")
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

        func testExample() throws {

            app.activate()
            XCTAssertTrue(app.isOnMainView)
            
            app.navigationBars["ToDoApp"].buttons["Add"].tap()
            app.textFields["Title"].tap()
            app.textFields["Title"].typeText("Foo")

            app.textFields["Location"].tap()
            app.textFields["Location"].typeText("Bar")

            app.textFields["Description"].tap()
            app.textFields["Description"].typeText("Baz")

            app.textFields["Date"].tap()
            app.textFields["Date"].typeText("01.01.22")

            app.textFields["Address"].tap()
            app.textFields["Address"].typeText("Astana")

            XCTAssertFalse(app.isOnMainView)
            app.buttons["Save"].tap()
            
    }
    
    func testWhenCellIsSwipedLeftDoneButtonAppeared() {
        

        app.activate()
        XCTAssertTrue(app.isOnMainView)
        
        app.navigationBars["ToDoApp"].buttons["Add"].tap()
        app.textFields["Title"].tap()
        app.textFields["Title"].typeText("Foo")

        app.textFields["Location"].tap()
        app.textFields["Location"].typeText("Bar")

        app.textFields["Description"].tap()
        app.textFields["Description"].typeText("Baz")

        app.textFields["Date"].tap()
        app.textFields["Date"].typeText("01.01.22")

        app.textFields["Address"].tap()
        app.textFields["Address"].typeText("Astana")

        XCTAssertFalse(app.isOnMainView)
        app.buttons["Save"].tap()
        
        let tablesQuery = app.tables.cells
        tablesQuery.element(boundBy: 0).swipeLeft()
        
        tablesQuery.element(boundBy: 0).buttons["Done"].tap()
        
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "date").label, "")
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

extension XCUIApplication {
    
    var isOnMainView: Bool {
        return otherElements["mainView"].exists
    }
}
