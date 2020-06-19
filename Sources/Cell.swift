import Foundation

struct Cell: Life {
    var active: Bool { life.active }
    var age: Int { life.age }
    
    @discardableResult mutating func die() -> Life {
        life = life.die()
        return self
    }
    
    @discardableResult mutating func live() -> Life {
        life = life.live()
        return self
    }
    
    func belongs(to: Automaton) -> Bool {
        life.belongs(to: to)
    }
    
    private var life: Life
    
    static func dead() -> Self {
        Self(life: Dead())
    }
    
    static func alive(automaton: Automaton) -> Self {
        Self(life: Live(automaton: automaton, age: 0))
    }
}

private struct Live: Life {
    let age: Int
    let active = true
    private weak var automaton: Automaton!
    
    init(automaton: Automaton, age: Int) {
        self.automaton = automaton
        self.age = age
    }
    
    func die() -> Life {
        Dead()
    }
    
    func live() -> Life {
        Live(automaton: automaton, age: age + 1)
    }
    
    func belongs(to: Automaton) -> Bool {
        automaton === to
    }
}

private struct Dead: Life {
    let age = -1
    let active = false
    
    func die() -> Life {
        self
    }
    
    func live() -> Life {
        self
    }
    
    func belongs(to: Automaton) -> Bool {
        false
    }
}
