import XCTest
@testable import Automata

final class GridTests: XCTestCase {
    private var grid: Grid!
    
    override func setUp() {
        grid = .init(size: 50)
    }
}
