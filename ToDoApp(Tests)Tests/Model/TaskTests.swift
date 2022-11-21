//
//  TaskTests.swift
//  ToDoApp(Tests)Tests
//
//  Created by Данил Прокопенко on 11.11.2022.
//

import XCTest
@testable import ToDoApp_Tests_

final class TaskTests: XCTestCase {
    
    func testInitTaskWithTitle() {
        let task = Task(title: "Foo")
        
        XCTAssertNotNil(task)
    }
    
    func testInitTaskWithTitleAndDescription() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertNotNil(task)
    }
    
    func testWhenGivenTitleSetsTitle() {
        let task = Task(title: "Foo")
        
        XCTAssertEqual(task.title, "Foo")
    }
    
    func testWhenGivenDescriptionSetsDescription() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertTrue(task.description == "Bar")
    }
    
    func testTaskInitsWithDate() {
        let task = Task(title: "Foo", description: "Bar")
        
        XCTAssertNotNil(task.date)
    }
    
    func testWhenGivenLocationSetsLocation() {
        let location = Location(name: "Foo")
        
        let task = Task(title: "Bar", location: location)
        
        XCTAssertEqual(location, task.location)
    }
    
    func testCanBeCreatedFromPlistDictionary() {
        let date = Date(timeIntervalSince1970: 10)
        let location = Location(name: "Baz")
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let locationDictionary: [String: Any] = [ "name" : "Baz" ]
        let dictionary: [String : Any] = ["title" : "Foo",
                                        "description" : "Bar",
                                        "date" : date,
                                        "location" : locationDictionary]
        
        let createdTask = Task(dict: dictionary)
        XCTAssertEqual(task, createdTask)
    }
    
    func testCanBeSerializedIntoDictionary() {
        let date = Date(timeIntervalSince1970: 10)
        let location = Location(name: "Baz")
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        
        let generatedTask = Task(dict: task.dict)
        
        XCTAssertEqual(task, generatedTask)
    }
    
}
