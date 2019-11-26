//
//  ContactsTests.swift
//  ContactsTests
//
//  Created by Anil Kumar on 19/11/19.
//  Copyright © 2019 Anil Kumar. All rights reserved.
//

import XCTest
@testable import Contacts

class ContactsTests: XCTestCase {
    
    var contactViewModel :ContactViewModel?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        contactViewModel = ContactViewModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        contactViewModel = nil
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
    
    
    func test_fetchContacts() {
        
        contactViewModel?.fetchAllContacts()
        
        let delayExpectation = expectation(description: "Waiting for Contacts to download")
        
        // Fulfill the expectation after 5 seconds
        // (which matches our document save interval)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            delayExpectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, if it takes more than
        // 5 seconds, throw an error
        waitForExpectations(timeout: 5)
        XCTAssertNotNil(contactViewModel?.contactsDictionary)
        XCTAssertNotNil(contactViewModel?.allSections)
        
        
    }
    
    
    
    
    
    
}
