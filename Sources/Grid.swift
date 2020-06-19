import Foundation

struct Grid {
    var oldest: Int {
        items.flatMap { $0.map(\.age) }.max() ?? 0
    }
    
    private(set) var items: [[Cell]]
    
    init(size: Int) {
        items = .init(repeating: .init(repeating: .dead(), count: size), count: size)
    }
    
    func contact(_ at: Point) -> [Automaton] {
        (at.x - 1 ... at.x + 1).flatMap { x in
            (at.y - 1 ... at.y + 1).reduce(into: []) {
                $0.append(Point(x, $1))
            }
        }.filter { $0 != at }.reduce(into: []) {
            guard $1.x >= 0 && $1.x < items.count && $1.y >= 0 && $1.y < items.count, let automaton = self[$1].automaton else { return }
            $0.append(automaton)
        }
    }
    
    func percent(_ of: Automaton) -> CGFloat {
        .init(items.map { $0.filter { $0.automaton == of }.count }.reduce(0, +)) / .init(items.count * items.count)
    }
    
    subscript(_ point: Point) -> Cell {
        get {
            items[point.x][point.y]
        }
        set {
            items[point.x][point.y] = newValue
        }
    }
}
