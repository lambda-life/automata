import XCTest
import Combine
@testable import Automata

final class UniverseTests: XCTestCase {
    private var universe: Universe!
    private var subs: Set<AnyCancellable>!
    
    override func setUp() {
        universe = .init(size: 10)
        subs = .init()
    }
    
    func testInitialSetup() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 5
        var received = [Point]()
        
        universe.born.sink {
            XCTAssertFalse(received.contains($0))
            received.append($0)
            expect.fulfill()
        }.store(in: &subs)
        
        universe.seed(5)
        waitForExpectations(timeout: 1)
    }
    
    func testZeroDies() {
        let expect = expectation(description: "")
        universe.die.sink {
            XCTAssertEqual(.init(5, 5), $0)
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = 0
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(-1, self.universe.grid[.init(5, 5)])
        }
    }
    
    func testOneDies() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        universe.die.sink {
            XCTAssertTrue($0 == .init(5, 5) || $0 == .init(6, 5))
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = 0
        universe.grid[.init(6, 5)] = 0
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(-1, self.universe.grid[.init(5, 5)])
            XCTAssertEqual(-1, self.universe.grid[.init(6, 5)])
        }
    }
    
    func testThreeReproduce() {
        let expect = expectation(description: "")
        universe.born.sink {
            XCTAssertEqual(.init(5, 4), $0)
            expect.fulfill()
        }.store(in: &subs)
        universe.die.sink { _ in
            XCTFail()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = 0
        universe.grid[.init(6, 5)] = 0
        universe.grid[.init(6, 4)] = 0
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(1, self.universe.grid[.init(5, 5)])
            XCTAssertEqual(1, self.universe.grid[.init(6, 5)])
            XCTAssertEqual(1, self.universe.grid[.init(6, 4)])
            XCTAssertEqual(0, self.universe.grid[.init(5, 4)])
        }
    }
    
    func testFourDies() {
        let expectDies = expectation(description: "")
        let expectBorn = expectation(description: "")
        expectDies.expectedFulfillmentCount = 5
        expectBorn.expectedFulfillmentCount = 4
        universe.born.sink { _ in
            expectBorn.fulfill()
        }.store(in: &subs)
        universe.die.sink { _ in
            expectDies.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = 0
        universe.grid[.init(6, 6)] = 0
        universe.grid[.init(6, 4)] = 0
        universe.grid[.init(4, 4)] = 0
        universe.grid[.init(4, 6)] = 0
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(-1, self.universe.grid[.init(5, 5)])
            XCTAssertEqual(-1, self.universe.grid[.init(6, 6)])
            XCTAssertEqual(-1, self.universe.grid[.init(6, 4)])
            XCTAssertEqual(-1, self.universe.grid[.init(4, 4)])
            XCTAssertEqual(-1, self.universe.grid[.init(4, 6)])
            
            XCTAssertEqual(0, self.universe.grid[.init(6, 5)])
            XCTAssertEqual(0, self.universe.grid[.init(5, 4)])
            XCTAssertEqual(0, self.universe.grid[.init(4, 5)])
            XCTAssertEqual(0, self.universe.grid[.init(5, 6)])
        }
    }
    
    func testAnotherFourDies() {
        let expectDies = expectation(description: "")
        let expectBorn = expectation(description: "")
        expectDies.expectedFulfillmentCount = 2
        expectBorn.expectedFulfillmentCount = 2
        universe.born.sink { _ in
            expectBorn.fulfill()
        }.store(in: &subs)
        universe.die.sink { _ in
            expectDies.fulfill()
        }.store(in: &subs)
        universe.grid[.init(0, 0)] = 0
        universe.grid[.init(1, 0)] = 0
        universe.grid[.init(0, 1)] = 0
        universe.grid[.init(1, 1)] = 0
        universe.grid[.init(1, 2)] = 0
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(-1, self.universe.grid[.init(1, 1)])
            XCTAssertEqual(-1, self.universe.grid[.init(0, 1)])
            
            XCTAssertEqual(0, self.universe.grid[.init(0, 2)])
            XCTAssertEqual(0, self.universe.grid[.init(2, 1)])
        }
    }
}
