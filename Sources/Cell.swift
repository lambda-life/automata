import Foundation

struct Cell: Life {
    var automaton: Automaton? { life.automaton }
    var age: Int { life.age }
    
    @discardableResult mutating func contact(_ cells: [Automaton]) -> Life {
        life = life.contact(cells)
        return self
    }
    
    private var life: Life
    
    static func dead() -> Self {
        Self(life: Dead())
    }
    
    static func alive(automaton: Automaton) -> Self {
        Self(life: Live(automaton: automaton))
    }
}

private struct Live: Life {
    private(set) weak var automaton: Automaton?
    let age: Int
    
    init(automaton: Automaton, age: Int = 0) {
        self.automaton = automaton
        self.age = age
    }
    
    func contact(_ cells: [Automaton]) -> Life {
        cells.count == 2 || cells.count == 3 ? Live(automaton: automaton!, age: age + 1) : Dead()
    }
}

private struct Dead: Life {
    private(set) weak var automaton: Automaton?
    let age = -1
    
    func contact(_ cells: [Automaton]) -> Life {
        cells.count == 3 ? Live(automaton: cells.reduce(into: [:]) {
            $0[$1] = $0[$1, default: 0] + 1
        }.sorted { $0.1 > $1.1 }.first!.0) : self
    }
}
