import Foundation
import CoreGraphics
import Combine

public final class Universe {
    public var percent: CGFloat {
        .init(grid.map { $0.filter { $0 }.count }.reduce(0, +)) / .init(size * size)
    }
    
    private var grid: [[Bool]]
    public let alive = PassthroughSubject<Point, Never>()
    public let size: Int
    
    public init(size: Int) {
        self.size = size
        grid = .init(repeating: .init(repeating: false, count: size), count: size)
    }
    
    public func add(random: Int) {
        (0 ..< random).forEach { _ in
            var x: Int
            var y: Int
            repeat {
                x = .random(in: 0 ..< size)
                y = .random(in: 0 ..< size)
            } while point(.init(x: x, y: y))
            
            grid[x][y] = true
            alive.send(.init(x: x, y: y))
        }
    }
    
    public func point(_ at: Point) -> Bool {
        grid[at.x][at.y]
    }
}
