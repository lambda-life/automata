import XCTest
import Combine
@testable import Automata

final class UniverseTests: XCTestCase {
    private var universe: Universe!
    private var automaton: Automaton!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        universe = .init(size: 10)
        subs = .init()
        automaton = .init()
    }
    
    func testInitialSetup() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 5
        var received = [Point]()
        
        universe.cell.sink {
            XCTAssertFalse(received.contains($0.1))
            received.append($0.1)
            expect.fulfill()
        }.store(in: &subs)
        
        universe.random(5, automaton: automaton)
        waitForExpectations(timeout: 1)
    }
    
    func testZeroDies() {
        let expect = expectation(description: "")
        universe.cell.sink {
            XCTAssertEqual(.init(5, 5), $0.1)
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = .alive(automaton: automaton)
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(-1, self.universe.grid[.init(5, 5)].age)
        }
    }
    
    func testOneDies() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        universe.cell.sink {
            XCTAssertTrue($0.1 == .init(5, 5) || $0.1 == .init(6, 5))
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = .alive(automaton: automaton)
        universe.grid[.init(6, 5)] = .alive(automaton: automaton)
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(-1, self.universe.grid[.init(5, 5)].age)
            XCTAssertEqual(-1, self.universe.grid[.init(6, 5)].age)
        }
    }
    
    func testThreeReproduce() {
        let expect = expectation(description: "")
        universe.cell.sink {
            XCTAssertEqual(.init(5, 4), $0.1)
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = .alive(automaton: automaton)
        universe.grid[.init(6, 5)] = .alive(automaton: automaton)
        universe.grid[.init(6, 4)] = .alive(automaton: automaton)
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(1, self.universe.grid[.init(5, 5)].age)
            XCTAssertEqual(1, self.universe.grid[.init(6, 5)].age)
            XCTAssertEqual(1, self.universe.grid[.init(6, 4)].age)
            XCTAssertEqual(0, self.universe.grid[.init(5, 4)].age)
        }
    }
    
    func testFourDies() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 9
        universe.cell.sink { _ in
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = .alive(automaton: automaton)
        universe.grid[.init(6, 6)] = .alive(automaton: automaton)
        universe.grid[.init(6, 4)] = .alive(automaton: automaton)
        universe.grid[.init(4, 4)] = .alive(automaton: automaton)
        universe.grid[.init(4, 6)] = .alive(automaton: automaton)
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(-1, self.universe.grid[.init(5, 5)].age)
            XCTAssertEqual(-1, self.universe.grid[.init(6, 6)].age)
            XCTAssertEqual(-1, self.universe.grid[.init(6, 4)].age)
            XCTAssertEqual(-1, self.universe.grid[.init(4, 4)].age)
            XCTAssertEqual(-1, self.universe.grid[.init(4, 6)].age)
            
            XCTAssertEqual(0, self.universe.grid[.init(6, 5)].age)
            XCTAssertEqual(0, self.universe.grid[.init(5, 4)].age)
            XCTAssertEqual(0, self.universe.grid[.init(4, 5)].age)
            XCTAssertEqual(0, self.universe.grid[.init(5, 6)].age)
        }
    }
    
    func testAnotherFourDies() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 4
        universe.cell.sink { _ in
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(0, 0)] = .alive(automaton: automaton)
        universe.grid[.init(1, 0)] = .alive(automaton: automaton)
        universe.grid[.init(0, 1)] = .alive(automaton: automaton)
        universe.grid[.init(1, 1)] = .alive(automaton: automaton)
        universe.grid[.init(1, 2)] = .alive(automaton: automaton)
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(-1, self.universe.grid[.init(1, 1)].age)
            XCTAssertEqual(-1, self.universe.grid[.init(0, 1)].age)
            
            XCTAssertEqual(0, self.universe.grid[.init(0, 2)].age)
            XCTAssertEqual(0, self.universe.grid[.init(2, 1)].age)
        }
    }
}
