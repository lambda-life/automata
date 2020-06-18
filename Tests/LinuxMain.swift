import XCTest

import automataTests

var tests = [XCTestCaseEntry]()
tests += automataTests.allTests()
XCTMain(tests)
