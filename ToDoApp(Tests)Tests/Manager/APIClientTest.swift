//
//  APIClientTest.swift
//  ToDoApp(Tests)Tests
//
//  Created by Данил Прокопенко on 16.11.2022.
//

import XCTest
@testable import ToDoApp_Tests_

final class APIClientTest: XCTestCase {

    var sut: APIClient!
    var mockUrlSession: MockURLSession!
    
    override func setUpWithError() throws {
        mockUrlSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut = APIClient()
        sut.urlSession = mockUrlSession
    }

    override func tearDownWithError() throws {
    }

    func userLogin() {
        let completionHandler = {(token: String?, error: Error?) in }
        sut.login(withName: "name", password: "%qwerty", completionHandler: completionHandler)
    }
    
    func testLoginUsesCorrectHost() {
        userLogin()
        XCTAssertEqual(mockUrlSession.urlComponents?.host, "todoapp.com")
    }
    
    func testLoginUsesCorrectPath() {
        userLogin()
        XCTAssertEqual(mockUrlSession.urlComponents?.path, "/login")
    }
    
    func testLoginUsesExpectedQueryParameters() {
        userLogin()
        
        guard let queryItems = mockUrlSession.urlComponents?.queryItems else {
            XCTFail(); return
        }
        let urlQueryItemName = URLQueryItem(name: "name", value: "name")
        let urlQueryItemPassword = URLQueryItem(name: "password", value: "%qwerty")
        XCTAssertTrue(queryItems.contains(urlQueryItemName))
        XCTAssertTrue(queryItems.contains(urlQueryItemPassword))
    }
    // token -> Data (completionHandler) -> DataTask -> UrlSession
    func testSuccessfulLoginCreatesToken() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        mockUrlSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: nil)
        sut.urlSession = mockUrlSession
        let tokenExpectation = expectation(description: "Token expectation")
        
        var caughtToken: String?
        sut.login(withName: "login", password: "password") { token, _ in
            caughtToken = token
            tokenExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(caughtToken, "tokenString")
        }
    }
    
    func testLoginInvalidJSONReturnsError() {
        mockUrlSession = MockURLSession(data: Data(), urlResponse: nil, responseError: nil)
        sut.urlSession = mockUrlSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    func testLoginWhenDataIsNilReturnsError() {
        mockUrlSession = MockURLSession(data: nil, urlResponse: nil, responseError: nil)
        sut.urlSession = mockUrlSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }
    
    func testLoginWhenResponseErrorReturnsError() {
        let jsonDataStub = "{\"token\": \"tokenString\"}".data(using: .utf8)
        let error = NSError(domain: "Server error", code: 404)
        mockUrlSession = MockURLSession(data: jsonDataStub, urlResponse: nil, responseError: error)
        sut.urlSession = mockUrlSession
        let errorExpectation = expectation(description: "Error expectation")
        
        var caughtError: Error?
        sut.login(withName: "login", password: "password") { _, error in
            caughtError = error
            errorExpectation.fulfill()
        }
        waitForExpectations(timeout: 1) { _ in
            XCTAssertNotNil(caughtError)
        }
    }

}

extension APIClientTest {
    
    class MockURLSession: URLSessionProtocol {
        
        var url: URL?
        private let mockDataTask: MockURLSessionDataTask
        
        var urlComponents: URLComponents? {
            guard let url = url else {
                return nil
            }
            return URLComponents(url: url, resolvingAgainstBaseURL: true)
            
        }
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            mockDataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, responseError: responseError)
        }
        
            func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
                self.url = url
    //            return URLSession.shared.dataTask(with: url)
                mockDataTask.completionHandler = completionHandler
                return mockDataTask
        }
    }
        
}
    
    class MockURLSessionDataTask:URLSessionDataTask {
        
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
        var completionHandler: CompletionHandler?
        
        init(data: Data?, urlResponse: URLResponse?, responseError: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = responseError
        }
    
        override func resume() {
            DispatchQueue.main.async {
                self.completionHandler!(self.data, self.urlResponse, self.responseError)
            }
        }
    }

