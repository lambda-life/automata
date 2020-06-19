import Foundation
import CoreGraphics
import Combine

public final class Universe {
    public var size: Int { grid.items.count }
    public let born = PassthroughSubject<Point, Never>()
    public let die = PassthroughSubject<Point, Never>()
    public let generation = CurrentValueSubject<Int, Never>(0)
    public let oldest = CurrentValueSubject<Int, Never>(0)
    public let percent = CurrentValueSubject<CGFloat, Never>(0)
    
    var grid: Grid {
        didSet {
            percent.value = grid.percent
            oldest.value = grid.oldest
        }
    }
    
    public init(size: Int) {
        grid = .init(size: size)
    }
    
    public func random(_ seed: Int) {
        var grid = self.grid
        (0 ..< seed).forEach { _ in
            var point: Point
            repeat {
                point = .init(.random(in: 0 ..< grid.items.count), .random(in: 0 ..< grid.items.count))
            } while grid[point] >= 0
            grid[point] = 0
            born.send(point)
        }
        self.grid = grid
    }
    
    public func seed(_ point: Point) {
        grid[point] = 0
        born.send(point)
    }
    
    public func tick() {
        var next = grid
        (0 ..< grid.items.count).flatMap { x in
            (0 ..< grid.items.count).reduce(into: []) {
                $0.append(Point(x, $1))
            }
        }.forEach {
            if grid[$0] >= 0 {
                switch grid.contact($0) {
                case 2, 3:
                    next[$0] += 1
                default:
                    next[$0] = -1
                    die.send($0)
                }
            } else {
                if grid.contact($0) == 3 {
                    next[$0] = 0
                    born.send($0)
                }
            }
        }
        grid = next
        generation.value += 1
    }
}
