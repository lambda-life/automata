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
        let expect = expectation(description: "")
        let automaton = Automaton()
        universe.cell.sink {
            XCTAssertEqual(automaton, $0.0)
            XCTAssertEqual(.init(0, 0), $0.1)
            expect.fulfill()
        }.store(in: &subs)
        universe.seed(.init(0, 0), automaton: automaton)
        XCTAssertEqual(0.01, universe.percent(automaton))
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(0, self.universe.grid[.init(0, 0)].age)
            XCTAssertEqual(automaton, self.universe.grid[.init(0, 0)].automaton)
        }
    }
    
    func testThreeDifferentAutomaton() {
        let expect = expectation(description: "")
        let a = Automaton()
        let b = Automaton()
        universe.cell.sink {
            XCTAssertEqual(.init(5, 4), $0.1)
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = .alive(automaton: b)
        universe.grid[.init(6, 5)] = .alive(automaton: a)
        universe.grid[.init(6, 4)] = .alive(automaton: b)
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(1, self.universe.grid[.init(5, 5)].age)
            XCTAssertEqual(1, self.universe.grid[.init(6, 5)].age)
            XCTAssertEqual(1, self.universe.grid[.init(6, 4)].age)
            XCTAssertEqual(0, self.universe.grid[.init(5, 4)].age)
            XCTAssertEqual(b, self.universe.grid[.init(5, 4)].automaton)
        }
    }
}
