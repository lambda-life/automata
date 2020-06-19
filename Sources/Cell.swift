import Foundation

struct Cell: Life, Equatable {
    var automaton: Automaton? { life.automaton }
    var age: Int { life.age }
    
    @discardableResult mutating func contact(_ cells: [Automaton: Int]) -> Life {
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
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.automaton == rhs.automaton && lhs.age == rhs.age
    }
}

private struct Live: Life {
    private(set) weak var automaton: Automaton?
    let age: Int
    
    init(automaton: Automaton, age: Int = 0) {
        self.automaton = automaton
        self.age = age
    }
    
    func contact(_ cells: [Automaton: Int]) -> Life {
        cells.count == 2 || cells.count == 3 ? Live(automaton: automaton!, age: age + 1) : Dead()
    }
}

private struct Dead: Life {
    private(set) weak var automaton: Automaton?
    let age = -1
    
    func contact(_ cells: [Automaton: Int]) -> Life {
        cells.count == 3 ? Live(automaton: cells.sorted { $0.1 > $1.1 }.first!.0) : self
    }
}
