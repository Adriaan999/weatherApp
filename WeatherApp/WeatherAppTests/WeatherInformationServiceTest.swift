//
//  WeatherInformationServiceTest.swift
//  WeatherAppTests
//
//  Created by Adriaan van Schalkwyk on 2022/01/17.
//

import XCTest

class WeatherInformationServiceTest: XCTestCase {
    
    private var interactor: WeatherInformationInteractor?
    
    override func setUp() {
        super.setUp()
        interactor = WeatherInformationInteractor()
    }
    
    func testFetchCurrentLocationData() {
        let testExpectation = expectation(description: "success response expectation")
        interactor?.fetchWeather(latitude: 0.0, longitude: 0.0, success: { (response) in
            XCTAssert(response?.id == 6295630)
            testExpectation.fulfill()
        }, failure: { (error) in
            XCTFail()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}
