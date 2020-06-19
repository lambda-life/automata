import XCTest
import Combine
@testable import Automata

final class EditTests: XCTestCase {
    private var universe: Universe!
    private var automaton: Automaton!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        universe = .init(size: 10)
        subs = .init()
        automaton = .init()
    }
    
    func testSeed() {
        let expect = expectation(description: "")
        universe.cell.sink {
            XCTAssertEqual(self.automaton, $0.0)
            XCTAssertEqual(.init(0, 0), $0.1)
            expect.fulfill()
        }.store(in: &subs)
        universe.seed(.init(0, 0), automaton: automaton)
        XCTAssertEqual(0.01, universe.percent(automaton))
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(0, self.universe.grid[.init(0, 0)].age)
            XCTAssertEqual(self.automaton, self.universe.grid[.init(0, 0)].automaton)
        }
    }
}
