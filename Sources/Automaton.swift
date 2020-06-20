import Foundation

open class Automaton: Hashable {
    public init() {
        
    }
    
    open func hash(into: inout Hasher) {
        
    }
    
    public static func == (lhs: Automaton, rhs: Automaton) -> Bool {
        lhs === rhs
    }
}
