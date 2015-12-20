//
//  GithubRepoTests.swift
//  GithubRepoTests
//
//  Created by Arturs Derkintis on 12/18/15.
//  Copyright © 2015 Starfly. All rights reserved.
//

import XCTest
@testable import GithubRepo

class GithubRepoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLanguagesQuery(){
        let provider = LanguagesProvider()
        let list = provider.generateSuggestions("Ja")
        XCTAssertEqual(list.count, 2)
    }
    func testReposProvider(){
        let provider = ReposotoriesProvider()
        let expectation = self.expectationWithDescription("Wait for repos")
        provider.getReposForLanguage("Swift") { (repos) -> Void in
            XCTAssertEqual(repos.count, 30)//Usually it returns top 30 repos array
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1000, handler: nil)
    }
    func testContributorsProvider(){
        let expectation = self.expectationWithDescription("Wait...")
        let provider = DetailsProvider()
        provider.getContributorsForRepo("Alamofire/Alamofire") { (contrs) -> Void in
            XCTAssertTrue(contrs.count > 0)//Check if there's returned at least 1 contributor
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1000, handler: nil)
    }
    func testIssuesProvider(){
        let expectation = self.expectationWithDescription("Wait...")
        let provider = DetailsProvider()
        provider.getIssuesForRepo("Alamofire/Alamofire") { (issues) -> Void in
            XCTAssertTrue(issues.count > 0)//Check if there's returned at least 1 issue. It will fail if there's no issues.
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(1000, handler: nil)
    }
}
