import XCTest
import Combine
@testable import Automata

final class EditTests: XCTestCase {
    private var universe: Universe!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        universe = .init(size: 10)
        subs = .init()
    }
    
    func testSeed() {
        let expectPercent = expectation(description: "")
        let expectBorn = expectation(description: "")
        universe.percent.dropFirst().sink {
            XCTAssertEqual(0.01, $0)
            expectPercent.fulfill()
        }.store(in: &subs)
        universe.born.sink {
            XCTAssertEqual(.init(0, 0), $0)
            expectBorn.fulfill()
        }.store(in: &subs)
        universe.seed(.init(0, 0))
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(0, self.universe.grid[.init(0, 0)])
        }
    }
}
