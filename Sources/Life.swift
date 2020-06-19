import Foundation

protocol Life {
    var automaton: Automaton? { get }
    var age: Int { get }
    
    mutating func contact(_ cells: [Automaton]) -> Life
}
