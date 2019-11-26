//
//  GitHubSwiftReposTests.swift
//  GitHubSwiftReposTests
//
//  Created by Bruno Fonseca de Almeida on 19/11/19.
//  Copyright © 2019 Bruno Fonseca de Almeida. All rights reserved.
//

import XCTest
@testable import GitHubSwiftRepos

class GitHubSwiftReposTests: XCTestCase {
  var viewController: ViewController!

  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
    viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Controller") as? ViewController

    _ = viewController.view
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() {
      // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testAPIManager() {
    let ex = expectation(description: "aguardar")

    APIManager.sharedInstance.getSwiftRepositories(page: 1, onSuccess:
    { json in
      ex.fulfill()
      XCTAssertEqual((json.dictionaryObject!["items"] as? [[String : Any]])?.count, 30, "Numero de objetos retornado é igual a 30")
      XCTAssertEqual((json.dictionaryObject!["items"] as? [[String : Any]])?[0]["name"] as! String, "awesome-ios", "Nome deve ser igual á awesome-ios")
     }, onFailure: { error in

     })

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
          // Put the code you want to measure the time of here.
      }
  }
}
