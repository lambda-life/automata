import Foundation

protocol Life {
    var active: Bool { get }
    var age: Int { get }
    
    mutating func die() -> Life
    mutating func live() -> Life
    func belongs(to: Automaton) -> Bool
}
