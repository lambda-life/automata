import XCTest
import Combine
@testable import Automata

final class StatusTests: XCTestCase {
    private var universe: Universe!
    private var automaton: Automaton!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        universe = .init(size: 10)
        subs = .init()
        automaton = .init()
    }
    
    func testPercent() {
        universe.random(50, automaton: automaton)
        XCTAssertEqual(0.5, universe.percent(automaton))
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
    
    func testOldest() {
        universe.grid[.init(0, 0)] = .alive(automaton: automaton)
        universe.grid[.init(1, 0)] = .alive(automaton: automaton)
        universe.grid[.init(0, 1)] = .alive(automaton: automaton)
        universe.grid[.init(1, 1)] = .alive(automaton: automaton)
        universe.tick()
        universe.tick()
        universe.tick()
        XCTAssertEqual(3, universe.oldest(automaton))
    }
    
    func testTwoAutomatons() {
        let second = Automaton()
        universe.grid[.init(0, 0)] = .alive(automaton: automaton)
        universe.grid[.init(1, 0)] = .alive(automaton: automaton)
        universe.grid[.init(0, 1)] = .alive(automaton: automaton)
        universe.grid[.init(1, 1)] = .alive(automaton: automaton)
        universe.tick()
        universe.tick()
        universe.tick()
        universe.grid[.init(4, 0)] = .alive(automaton: second)
        universe.grid[.init(5, 0)] = .alive(automaton: second)
        universe.grid[.init(4, 1)] = .alive(automaton: second)
        universe.grid[.init(5, 1)] = .alive(automaton: second)
        universe.tick()
        universe.tick()
        universe.tick()
        universe.grid[.init(8, 1)] = .alive(automaton: second)
        XCTAssertEqual(6, universe.oldest(automaton))
        XCTAssertEqual(3, universe.oldest(second))
        XCTAssertEqual(0.04, universe.percent(automaton))
        XCTAssertEqual(0.05, universe.percent(second))
    }
}
