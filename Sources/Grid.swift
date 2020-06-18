import Foundation

public struct Grid {
    public var percent: CGFloat {
        .init(items.map { $0.filter { $0 >= 0 }.count }.reduce(0, +)) / .init(items.count * items.count)
    }
    
    private(set) var items: [[Int]]
    
    init(size: Int) {
        items = .init(repeating: .init(repeating: -1, count: size), count: size)
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
