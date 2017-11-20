//
//  CampSiteServiceTests.swift
//  CampgroundManager
//
//  Created by Hai Vo L. on 11/17/17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import XCTest
import CoreData
import UIKit
@testable import CampgroundManager

class CampSiteServiceTests: XCTestCase {

  // MARK: - Properties
  var campSiteService: CampSiteService!
  var coreDataStack: CoreDataStack!

  override func setUp() {
    super.setUp()
    coreDataStack = TestCoreDataStack()
    campSiteService = CampSiteService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
  }

  override func tearDown() {
    campSiteService = nil
    coreDataStack = nil
    super.tearDown()
  }

  func testRootContextIsSavedAfterAddingCampsite() {
    let derivedContext = coreDataStack.newDerivedContext()

    campSiteService = CampSiteService(
      managedObjectContext: derivedContext,
      coreDataStack: coreDataStack)

    expectation(
      forNotification: NSNotification.Name.NSManagedObjectContextDidSave.rawValue,
      object: coreDataStack.mainContext) {
        notification in
        return true
    }

    let campSite = campSiteService.addCampSite(1, electricity: true, water: true)
    XCTAssertNotNil(campSite)

    waitForExpectations(timeout: 2.0) { error in
      XCTAssertNil(error, "Save did not occur")
    }
  }

  func testAddCampSite() {
    let campSite = campSiteService.addCampSite(1, electricity: true, water: true)

    XCTAssertTrue(campSite.siteNumber == 1, "Site number should be 1")
    XCTAssertTrue(campSite.electricity!.boolValue, "Site should have electricity")
    XCTAssertTrue(campSite.water!.boolValue, "Site should have water")
  }

  func testGetCampSiteWithMatchingSiteNumber() {
    _ = campSiteService.addCampSite(1,
                                    electricity: true,
                                    water: true)

    let campSite = campSiteService.getCampSite(1)
    XCTAssertNotNil(campSite, "A campsite should be returned")
  }

  func testGetCampSiteNoMatchingSiteNumber() {
    _ = campSiteService.addCampSite(1,
                                    electricity: true,
                                    water: true)

    let campSite = campSiteService.getCampSite(2)
    XCTAssertNil(campSite, "No campsite should be returned")
  }
}
