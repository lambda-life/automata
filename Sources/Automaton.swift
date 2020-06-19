import Foundation

public final class Automaton: Hashable {
    public func hash(into: inout Hasher) {
        
    }
    
    public static func == (lhs: Automaton, rhs: Automaton) -> Bool {
        lhs === rhs
    }
}
