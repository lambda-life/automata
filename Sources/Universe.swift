import Foundation
import CoreGraphics
import Combine

public final class Universe {
    public var size: Int { grid.items.count }
    public let cell = PassthroughSubject<(Automaton?, Point), Never>()
    public let generation = CurrentValueSubject<Int, Never>(0)
    var grid: Grid
    
    public init(size: Int) {
        grid = .init(size: size)
    }
    
    public func random(_ seed: Int, automaton: Automaton) {
        var grid = self.grid
        (0 ..< seed).forEach { _ in
            let point = grid.random
            grid[point] = .alive(automaton: automaton)
            cell.send((automaton, point))
        }
        self.grid = grid
    }
    
    public func seed(_ point: Point, automaton: Automaton) {
        grid[point] = .alive(automaton: automaton)
        cell.send((automaton, point))
    }
    
    public func tick() {
        var next = grid
        (0 ..< grid.items.count).flatMap { x in
            (0 ..< grid.items.count).reduce(into: []) {
                $0.append(Point(x, $1))
            }
        }.forEach {
            if grid[$0].automaton != next[$0].contact(grid.contact($0)).automaton {
                cell.send((next[$0].automaton, $0))
            }
        }
        grid = next
        generation.value += 1
    }
    
    public func percent(_ of: Automaton) -> CGFloat {
        grid.percent(of)
    }
    
    public func oldest(_ of: Automaton) -> Int {
        grid.oldest(of)
    }
    
    public func sequence(_ size: Int) -> [Point] {
        (0 ..< size).map { _ in grid.random }
    }
}
