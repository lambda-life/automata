import Foundation

struct Grid {
    var percent: CGFloat {
        .init(items.map { $0.filter { $0 >= 0 }.count }.reduce(0, +)) / .init(items.count * items.count)
    }
    
    var oldest: Int {
        items.flatMap { $0 }.max() ?? 0
    }
    
    private(set) var items: [[Int]]
    
    init(size: Int) {
        items = .init(repeating: .init(repeating: -1, count: size), count: size)
    }
    
    func contact(_ at: Point) -> Int {
        (at.x - 1 ... at.x + 1).flatMap { x in
            (at.y - 1 ... at.y + 1).reduce(into: []) {
                $0.append(Point(x, $1))
            }
        }.filter { $0 != at }.reduce(into: 0) {
            if $1.x >= 0 && $1.x < items.count && $1.y >= 0 && $1.y < items.count {
                $0 += self[$1] >= 0 ? 1 : 0
            }
        }
    }
    
    subscript(_ point: Point) -> Int {
        get {
            items[point.x][point.y]
        }
        set {
            items[point.x][point.y] = newValue
        }
    }
}
