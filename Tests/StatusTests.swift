import XCTest
import Combine
@testable import Automata

final class StatusTests: XCTestCase {
    private var universe: Universe!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        universe = .init(size: 10)
        subs = .init()
    }
    
    func testPercent() {
        let expect = expectation(description: "")
        universe.percent.dropFirst().sink {
            XCTAssertEqual(0.5, $0)
            expect.fulfill()
        }.store(in: &subs)
        universe.seed(50)
        waitForExpectations(timeout: 1)
    }
    
    func testGeneration() {
        let expect = expectation(description: "")
        universe.generation.dropFirst().sink {
            XCTAssertEqual(1, $0)
            expect.fulfill()
        }.store(in: &subs)
        universe.tick()
        waitForExpectations(timeout: 1)
    }
}
