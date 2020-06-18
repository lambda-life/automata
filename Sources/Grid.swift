import Foundation

public final class Grid {
    public let size: Int
    
    public init(size: Int) {
        self.size = size
    }
    
    public func point(_ at: CGPoint) -> Bool {
        false
    }
}
