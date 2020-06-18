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
        expect.expectedFulfillmentCount = 50
        XCTAssertEqual(0, universe.grid.percent)
        var received = [Point]()
        
        universe.born.sink {
            XCTAssertFalse(received.contains($0))
            received.append($0)
            expect.fulfill()
        }.store(in: &subs)
        
        universe.seed(50)
        XCTAssertEqual(0.5, universe.grid.percent)
        waitForExpectations(timeout: 1)
    }
    
    func testZip() {
        (0 ..< 10).flatMap { x in
            (0 ..< 10).reduce(into: []) {
                $0.append(Point(x, $1))
            }
        }.forEach { a in
            print(a)
        }
//        zip((0 ..< 10), (0 ..< 1)).forEach {
//            print("x: \($1), y: \($1)")
//        }
    }
    
    func testZeroDies() {
        let expect = expectation(description: "")
        universe.die.sink {
            XCTAssertEqual(.init(5, 5), $0)
            XCTAssertEqual(-1, self.universe.grid[.init(5, 5)])
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = 0
        universe.tick()
        waitForExpectations(timeout: 1)
    }
    
    func testOneDies() {
        let expect = expectation(description: "")
        expect.expectedFulfillmentCount = 2
        universe.die.sink {
            XCTAssertTrue($0 == .init(5, 5) || $0 == .init(6, 5))
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5, 5)] = 0
        universe.grid[.init(5, 5)] = 0
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(0, self.universe.grid[.init(5, 5)])
            XCTAssertEqual(0, self.universe.grid[.init(6, 5)])
        }
    }
    
    func testThreeReproduce() {
        let expect = expectation(description: "")
        universe.born.sink {
            XCTAssertEqual(.init(5, 4), $0)
            expect.fulfill()
        }.store(in: &subs)
        universe.grid[.init(5,5)] = 0
        universe.grid[.init(6,5)] = 0
        universe.grid[.init(6,4)] = 0
        universe.tick()
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(0, self.universe.grid[.init(5, 5)])
            XCTAssertEqual(0, self.universe.grid[.init(6, 5)])
            XCTAssertEqual(0, self.universe.grid[.init(6, 4)])
            XCTAssertEqual(0, self.universe.grid[.init(5, 4)])
        }
    }
}
