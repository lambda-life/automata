import Foundation
import CoreGraphics
import Combine

public final class Universe {
    public let born = PassthroughSubject<Point, Never>()
    public let die = PassthroughSubject<Point, Never>()
    public internal(set) var grid: Grid
    
    public init(size: Int) {
        grid = .init(size: size)
    }
    
    public func seed(_ count: Int) {
        (0 ..< count).forEach { _ in
            var point: Point
            repeat {
                point = .init(.random(in: 0 ..< grid.items.count), .random(in: 0 ..< grid.items.count))
            } while grid[point] >= 0
            grid[point] = 0
            born.send(point)
        }
    }
    
    public func tick() {
        zip(0 ..< grid.items.count, 0 ..< grid.items.count).forEach { x, y in
            
        }
//        for x in 0 ..< grid.items.count {
//            for y in 0 ..< grid.items.count {
//                if grid[x][y] {
//                    grid[x][y] = false
//                    die.send(.init(x, y))
//                } else {
//                    var count = 0
//                    if x > 0 {
//                        if y > 0 {
//                            count += grid[x - 1][y - 1] ? 1 : 0
//                        }
//                        count += grid[x - 1][y] ? 1 : 0
//                        if y < size - 1 {
//                            count += grid[x - 1][y + 1] ? 1 : 0
//                        }
//                    }
//                    if x < size - 1 {
//                        if y > 0 {
//                            count += grid[x + 1][y - 1] ? 1 : 0
//                        }
//                        count += grid[x + 1][y] ? 1 : 0
//                        if y < size - 1 {
//                            count += grid[x + 1][y + 1] ? 1 : 0
//                        }
//                    }
//                    if y > 0 {
//                        count += grid[x][y - 1] ? 1 : 0
//                    }
//                    if y < size - 1 {
//                        count += grid[x][y + 1] ? 1 : 0
//                    }
//
//                    if count == 3 {
//                        grid[x][y] = true
//                        born.send(.init(x, y))
//                    }
//                }
//            }
//        }
    }
}
