class Person {
    let name:String
    var candidateIndex = 0
    var fiance:Person?
    var candidates = [Person]()

    init(name:String) {
        self.name = name
    }

    func rank(p:Person) -> Int {
        for (i, candidate) in enumerate(self.candidates) {
            if candidate === p {
                return i
            }
        }
        return self.candidates.count + 1
    }

    func prefers(p:Person) -> Bool {
        if let fiance = self.fiance {
            return self.rank(p) < self.rank(fiance)
        }
        return false
    }

    func nextCandidate() -> Person? {
        if self.candidateIndex >= self.candidates.count {
            return nil
        }
        return self.candidates[candidateIndex++]
    }

    func engageTo(p:Person) {
        p.fiance?.fiance = nil
        p.fiance = self
        self.fiance?.fiance = nil
        self.fiance = p
    }

    func swapWith(p:Person) {
        let thisFiance = self.fiance
        let pFiance = p.fiance
        println("\(self.name) swapped partners with \(p.name)")
        if pFiance != nil && thisFiance != nil {
            self.engageTo(pFiance!)
            p.engageTo(thisFiance!)
        }
    }
}

func isStable(guys:[Person], gals:[Person]) -> Bool {
    for guy in guys {
        for gal in gals {
            if guy.prefers(gal) && gal.prefers(guy) {
                return false
            }
        }
    }
    return true
}

func engageEveryone(guys:[Person]) {
    var done = false
    while !done {
        done = true
        for guy in guys {
            if guy.fiance == nil {
                done = false
                if let gal = guy.nextCandidate() {
                    if gal.fiance == nil || gal.prefers(guy) {
                        guy.engageTo(gal)
                    }
                }
            }
        }
    }
}

func doMarriage() {
    let abe  = Person(name: "Abe")
    let bob  = Person(name: "Bob")
    let col  = Person(name: "Col")
    let dan  = Person(name: "Dan")
    let ed   = Person(name: "Ed")
    let fred = Person(name: "Fred")
    let gav  = Person(name: "Gav")
    let hal  = Person(name: "Hal")
    let ian  = Person(name: "Ian")
    let jon  = Person(name: "Jon")
    let abi  = Person(name: "Abi")
    let bea  = Person(name: "Bea")
    let cath = Person(name: "Cath")
    let dee  = Person(name: "Dee")
    let eve  = Person(name: "Eve")
    let fay  = Person(name: "Fay")
    let gay  = Person(name: "Gay")
    let hope = Person(name: "Hope")
    let ivy  = Person(name: "Ivy")
    let jan  = Person(name: "Jan")

    abe.candidates  = [abi, eve, cath, ivy, jan, dee, fay, bea, hope, gay]
    bob.candidates  = [cath, hope, abi, dee, eve, fay, bea, jan, ivy, gay]
    col.candidates  = [hope, eve, abi, dee, bea, fay, ivy, gay, cath, jan]
    dan.candidates  = [ivy, fay, dee, gay, hope, eve, jan, bea, cath, abi]
    ed.candidates   = [jan, dee, bea, cath, fay, eve, abi, ivy, hope, gay]
    fred.candidates = [bea, abi, dee, gay, eve, ivy, cath, jan, hope, fay]
    gav.candidates  = [gay, eve, ivy, bea, cath, abi, dee, hope, jan, fay]
    hal.candidates  = [abi, eve, hope, fay, ivy, cath, jan, bea, gay, dee]
    ian.candidates  = [hope, cath, dee, gay, bea, abi, fay, ivy, jan, eve]
    jon.candidates  = [abi, fay, jan, gay, eve, bea, dee, cath, ivy, hope]
    abi.candidates  = [bob, fred, jon, gav, ian, abe, dan, ed, col, hal]
    bea.candidates  = [bob, abe, col, fred, gav, dan, ian, ed, jon, hal]
    cath.candidates = [fred, bob, ed, gav, hal, col, ian, abe, dan, jon]
    dee.candidates  = [fred, jon, col, abe, ian, hal, gav, dan, bob, ed]
    eve.candidates  = [jon, hal, fred, dan, abe, gav, col, ed, ian, bob]
    fay.candidates  = [bob, abe, ed, ian, jon, dan, fred, gav, col, hal]
    gay.candidates  = [jon, gav, hal, fred, bob, abe, col, ed, dan, ian]
    hope.candidates = [gav, jon, bob, abe, ian, dan, hal, ed, col, fred]
    ivy.candidates  = [ian, col, hal, gav, fred, bob, abe, ed, jon, dan]
    jan.candidates  = [ed, hal, gav, abe, bob, jon, col, ian, fred, dan]

    let guys = [abe, bob, col, dan, ed, fred, gav, hal, ian, jon]
    let gals = [abi, bea, cath, dee, eve, fay, gay, hope, ivy, jan]

    engageEveryone(guys)

    for guy in guys {
        println("\(guy.name) is engaged to \(guy.fiance!.name)")
    }

    println("Stable = \(isStable(guys, gals))")
    jon.swapWith(fred)
    println("Stable = \(isStable(guys, gals))")

}

doMarriage()
