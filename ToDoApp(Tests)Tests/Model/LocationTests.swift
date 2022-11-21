//
//  LocationTests.swift
//  ToDoApp(Tests)Tests
//
//  Created by Данил Прокопенко on 11.11.2022.
//

import XCTest
import CoreLocation

@testable import ToDoApp_Tests_

final class LocationTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }
    
    func testInitSetsName() {
        let location = Location(name: "Foo")
        
        XCTAssertEqual(location.name, "Foo")
    }

    func testInitSetsCoordinates() {
        let coordinate = CLLocationCoordinate2D(latitude: 1, longitude: 2)
        
        let location = Location(name: "Foo", coordinate: coordinate)
        
        XCTAssertEqual(location.coordinate?.latitude, coordinate.latitude)
        XCTAssertEqual(location.coordinate?.longitude, coordinate.longitude)
    }
    
    func testCanBeCreatedFromPlistDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0))
        let dict: [String : Any] = ["name" : "Foo",
                                    "latitude" : 10.0,
                                    "longitude" : 10.0
        ]
        
        let createdLocation = Location(dict: dict)
        
        XCTAssertEqual(location, createdLocation)
    }
    
    func testCanBeSerializedIntoDictionary() {
        let location = Location(name: "Foo", coordinate: CLLocationCoordinate2D(latitude: 10.0, longitude: 10.0))
        
        let generatedLocation = Location(dict: location.dict)
        
        XCTAssertEqual(location, generatedLocation)
    }

}
