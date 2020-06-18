import XCTest
@testable import automata

final class automataTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(automata().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
