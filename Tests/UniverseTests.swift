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
        XCTAssertEqual(0, universe.percent)
        var received = [Point]()
        
        universe.alive.sink {
            XCTAssertFalse(received.contains($0))
            received.append($0)
            expect.fulfill()
        }.store(in: &subs)
        
        universe.add(random: 50)
        XCTAssertEqual(0.5, universe.percent)
        waitForExpectations(timeout: 1)
    }
}
