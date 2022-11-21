//
//  DetailViewControllerTests.swift
//  ToDoApp(Tests)Tests
//
//  Created by Данил Прокопенко on 15.11.2022.
//

import XCTest
import CoreLocation
@testable import ToDoApp_Tests_

final class DetailViewControllerTests: XCTestCase {

    var sut: DetailViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHasTitleLabel() {
        XCTAssertNotNil(sut.titleLabel)
        XCTAssertTrue(sut.titleLabel.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionLabel() {
        XCTAssertNotNil(sut.descriptionLabel)
        XCTAssertTrue(sut.descriptionLabel.isDescendant(of: sut.view))
    }
    
    func testHasDateLabel() {
        XCTAssertNotNil(sut.dateLabel)
        XCTAssertTrue(sut.dateLabel.isDescendant(of: sut.view))
    }
    
    func testHasLocationLabel() {
        XCTAssertNotNil(sut.locationLabel)
        XCTAssertTrue(sut.locationLabel.isDescendant(of: sut.view))
    }

    
    func testHasMapView() {
        XCTAssertNotNil(sut.mapView)
        XCTAssertTrue(sut.mapView.isDescendant(of: sut.view))
    }
    
    func setupTaskAndAppearanceTransition() {
        let coordinate = CLLocationCoordinate2D(latitude: 51.1530782, longitude: 71.41971588)
        let location = Location(name: "Baz", coordinate: coordinate)
        let date = Date(timeIntervalSince1970: 1640973600)
        let task = Task(title: "Foo", description: "Bar", date: date, location: location)
        sut.task = task
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
    }
    func testSettingTaskSetsTitleLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.titleLabel.text, sut.task.title)
    }
    
    func testSettingTaskSetsDescriptionLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.descriptionLabel.text, sut.task.description)
    }
    
    func testSettingTaskSetsLocationLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.locationLabel.text, sut.task.location?.name)
    }
    
    func testSettingTaskSetsDateLabel() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.dateLabel.text, "01.01.22")
    }
    
    func testSettingTaskSetsMapView() {
        setupTaskAndAppearanceTransition()
        
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, 51.1530782, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, 71.41971588, accuracy: 0.001)
    }
    
    
}
