//
//  DeliveryAppUITests.swift
//  DeliveryAppUITests
//
//  Created by Siddharth Patel.
//  Copyright © Siddharth Patel. All rights reserved.
//

import XCTest

final class DeliveryAppUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAppLaunchAndTabNavigation() {
        let app = XCUIApplication()
        app.launch()

        // Verify initial home screen presence
        XCTAssertTrue(app.staticTexts["Categories"].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["Popular Now"].exists)
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
