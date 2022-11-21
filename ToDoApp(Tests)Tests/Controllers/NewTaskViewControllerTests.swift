//
//  NewTaskViewControllerTests.swift
//  ToDoApp(Tests)Tests
//
//  Created by Данил Прокопенко on 21.11.2022.
//


import XCTest
import CoreLocation
import Intents
import Contacts
@testable import ToDoApp_Tests_
final class NewTaskViewControllerTests: XCTestCase {

    var sut: NewTaskViewController!
    var placemark: MockCLPlacemark!
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: String(describing: NewTaskViewController.self)) as? NewTaskViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
    
    }

    func testHasTitleTextField() {
        XCTAssertTrue(sut.titleTextField.isDescendant(of: sut.view))
    }
    
    func testHasLocationTextField() {
        XCTAssertTrue(sut.locationTextField.isDescendant(of: sut.view))
    }
    
    func testHasDateTextField() {
        XCTAssertTrue(sut.dateTextField.isDescendant(of: sut.view))
    }
    
    func testHasAddressTextField() {
        XCTAssertTrue(sut.addressTextField.isDescendant(of: sut.view))
    }
    
    func testHasDescriptionTextField() {
        XCTAssertTrue(sut.descriptionTextField.isDescendant(of: sut.view))
    }
    
    func testHasSaveButton() {
        XCTAssertTrue(sut.saveButton.isDescendant(of: sut.view))
    }
    
    func testHasCancelButton() {
        XCTAssertTrue(sut.cancelButton.isDescendant(of: sut.view))
    }
    
    func testSaveButtonHasSaveMethod() {
        let saveButton = sut.saveButton

        guard let actions = saveButton?.actions(forTarget: sut, forControlEvent: .touchUpInside) else {XCTFail()
            return
        }

        XCTAssertTrue(actions.contains("save"))
    }
    
    func testGeocoderFetchesCorrectCoordinate() {
        let geocoderAnswer = expectation(description: "Geocoder answer")
        let addressString = "Астана"
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            let placemark = placemarks?.first
            let location = placemark?.location
            
            guard let latitude = location?.coordinate.latitude, let longitude = location?.coordinate.longitude else { XCTFail(); return}
            
            XCTAssertEqual(latitude, 51.1668879)
            XCTAssertEqual(longitude, 71.4211496)
            geocoderAnswer.fulfill()
            
        }
        waitForExpectations(timeout: 5)
    }
    
    func testSaveDismissesNewTaskViewController() {
        let mockNewTaskVC = MockNewTaskViewController()
        mockNewTaskVC.titleTextField = UITextField()
        mockNewTaskVC.titleTextField.text = "Foo"
        mockNewTaskVC.descriptionTextField = UITextField()
        mockNewTaskVC.descriptionTextField.text = "Bar"
        mockNewTaskVC.locationTextField = UITextField()
        mockNewTaskVC.locationTextField.text = "Baz"
        mockNewTaskVC.addressTextField = UITextField()
        mockNewTaskVC.addressTextField.text = "Astana"
        mockNewTaskVC.dateTextField = UITextField()
        mockNewTaskVC.dateTextField.text = "01.01.22"
        
        mockNewTaskVC.save()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(mockNewTaskVC.isDismissed)
        }

    }
    
    
    
}


extension NewTaskViewControllerTests {
    
    class MockClGeocoder: CLGeocoder {
        var completionHander: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHander = completionHandler
        }
    }
    
    class MockCLPlacemark: CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D!
        
        override var location: CLLocation? {
            return CLLocation(latitude: mockCoordinate.latitude, longitude: mockCoordinate.longitude)
        }
    }
}

extension NewTaskViewControllerTests {
    
    class MockNewTaskViewController: NewTaskViewController {
        var isDismissed = false
        
        override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
            isDismissed = true
        }
    }
    
}
