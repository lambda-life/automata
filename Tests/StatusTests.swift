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
        let expect = expectation(description: "")
        universe.percent.dropFirst().sink {
            XCTAssertEqual(0.5, $0)
            expect.fulfill()
        }.store(in: &subs)
        universe.random(50, automaton: automaton)
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
    
    func testOldest() {
        let expect = expectation(description: "")
        universe.grid[.init(0, 0)] = .alive(automaton: automaton)
        universe.grid[.init(1, 0)] = .alive(automaton: automaton)
        universe.grid[.init(0, 1)] = .alive(automaton: automaton)
        universe.grid[.init(1, 1)] = .alive(automaton: automaton)
        universe.tick()
        universe.tick()
        universe.oldest.dropFirst().sink {
            XCTAssertEqual(3, $0)
            expect.fulfill()
        }.store(in: &subs)
        universe.tick()
        waitForExpectations(timeout: 1)
    }
}
