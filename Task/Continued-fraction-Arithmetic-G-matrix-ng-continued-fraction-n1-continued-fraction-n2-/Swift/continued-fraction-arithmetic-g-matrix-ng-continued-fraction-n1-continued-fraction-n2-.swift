import Foundation

class MatrixNG {
    var cfn = 0
    var thisTerm = 0
    var haveTerm = false

    func consumeTerm() {
        fatalError("Must be overridden")
    }

    func consumeTerm(n: Int) {
        fatalError("Must be overridden")
    }

    func needTerm() -> Bool {
        fatalError("Must be overridden")
    }
}

class NG4: MatrixNG {
    var a1: Int
    var a: Int
    var b1: Int
    var b: Int

    init(a1: Int, a: Int, b1: Int, b: Int) {
        self.a1 = a1
        self.a = a
        self.b1 = b1
        self.b = b
    }

    override func needTerm() -> Bool {
        if b1 == 0 && b == 0 { return false }
        if b1 == 0 || b == 0 { return true }
        self.thisTerm = a / b
        if self.thisTerm == a1 / b1 {
            let t = a
            a = b
            b = t - b * self.thisTerm
            let t1 = a1
            a1 = b1
            b1 = t1 - b1 * self.thisTerm
            haveTerm = true
            return false
        }
        return true
    }

    override func consumeTerm() {
        a = a1
        b = b1
    }

    override func consumeTerm(n: Int) {
        let t = a
        a = a1
        a1 = t + a1 * n
        let t2 = b
        b = b1
        b1 = t2 + b1 * n
    }
}

class NG8: MatrixNG {
    var a12: Int
    var a1: Int
    var a2: Int
    var a: Int
    var b12: Int
    var b1: Int
    var b2: Int
    var b: Int

    init(a12: Int, a1: Int, a2: Int, a: Int, b12: Int, b1: Int, b2: Int, b: Int) {
        self.a12 = a12
        self.a1 = a1
        self.a2 = a2
        self.a = a
        self.b12 = b12
        self.b1 = b1
        self.b2 = b2
        self.b = b
    }

    private func chooseCFN() -> Int {
        let ab = Double(a) / Double(b)
        let a1b1 = Double(a1) / Double(b1)
        let a2b2 = Double(a2) / Double(b2)
        let a12b12 = Double(a12) / Double(b12)
        return abs(a1b1 - ab) > abs(a2b2 - ab) ? 0 : 1
    }

    override func needTerm() -> Bool {
        if b1 == 0 && b == 0 && b2 == 0 && b12 == 0 { return false }
        if b == 0 {
            cfn = b2 == 0 ? 0 : 1
            return true
        }
        let ab = Double(a) / Double(b)
        if b2 == 0 {
            cfn = 1
            return true
        }
        let a2b2 = Double(a2) / Double(b2)
        if b1 == 0 {
            cfn = 0
            return true
        }
        let a1b1 = Double(a1) / Double(b1)
        if b12 == 0 {
            cfn = chooseCFN()
            return true
        }
        let a12b12 = Double(a12) / Double(b12)
        self.thisTerm = Int(ab)
        if self.thisTerm == Int(a1b1) && self.thisTerm == Int(a2b2) && self.thisTerm == Int(a12b12) {
            let t = a
            a = b
            b = t - b * self.thisTerm
            let t1 = a1
            a1 = b1
            b1 = t1 - b1 * self.thisTerm
            let t2 = a2
            a2 = b2
            b2 = t2 - b2 * self.thisTerm
            let t3 = a12
            a12 = b12
            b12 = t3 - b12 * self.thisTerm
            haveTerm = true
            return false
        }
        cfn = chooseCFN()
        return true
    }

    override func consumeTerm() {
        if cfn == 0 {
            a = a1
            a2 = a12
            b = b1
            b2 = b12
        } else {
            a = a2
            a1 = a12
            b = b2
            b1 = b12
        }
    }

    override func consumeTerm(n: Int) {
        if cfn == 0 {
            let t = a
            a = a1
            a1 = t + a1 * n
            let t2 = a2
            a2 = a12
            a12 = t2 + a12 * n
            let t3 = b
            b = b1
            b1 = t3 + b1 * n
            let t4 = b2
            b2 = b12
            b12 = t4 + b12 * n
        } else {
            let t = a
            a = a2
            a2 = t + a2 * n
            let t2 = a1
            a1 = a12
            a12 = t2 + a12 * n
            let t3 = b
            b = b2
            b2 = t3 + b2 * n
            let t4 = b1
            b1 = b12
            b12 = t4 + b12 * n
        }
    }
}

protocol ContinuedFraction {
    func nextTerm() -> Int
    func moreTerms() -> Bool
}

class R2cf: ContinuedFraction {
    var n1: Int
    var n2: Int

    init(n1: Int, n2: Int) {
        self.n1 = n1
        self.n2 = n2
    }

    func nextTerm() -> Int {
        let thisTerm = n1 / n2
        let t2 = n2
        n2 = n1 - thisTerm * n2
        n1 = t2
        return thisTerm
    }

    func moreTerms() -> Bool {
        return abs(n2) > 0
    }
}

class NG: ContinuedFraction {
    let ng: MatrixNG
    let n: [ContinuedFraction]

    init(ng: NG4, n1: ContinuedFraction) {
        self.ng = ng
        self.n = [n1]
    }

    init(ng: NG8, n1: ContinuedFraction, n2: ContinuedFraction) {
        self.ng = ng
        self.n = [n1, n2]
    }

    func nextTerm() -> Int {
        ng.haveTerm = false
        return ng.thisTerm
    }

    func moreTerms() -> Bool {
        while ng.needTerm() {
            if n[ng.cfn].moreTerms() {
                ng.consumeTerm(n: n[ng.cfn].nextTerm())
            } else {
                ng.consumeTerm()
            }
        }
        return ng.haveTerm
    }
}

func test(desc: String, cfs: ContinuedFraction...) {
    print("TESTING -> \(desc)")
    for cf in cfs {
        while cf.moreTerms() {
            print("\(cf.nextTerm()) ", terminator: "")
        }
        print()
    }
    print()
}

func main() {
    let a = NG8(a12: 0, a1: 1, a2: 1, a: 0, b12: 0, b1: 0, b2: 0, b: 1)
    let n2 = R2cf(n1: 22, n2: 7)
    let n1 = R2cf(n1: 1, n2: 2)
    let a3 = NG4(a1: 2, a: 1, b1: 0, b: 2)
    let n3 = R2cf(n1: 22, n2: 7)
    test(desc: "[3;7] + [0;2]", cfs: NG(ng: a, n1: n1, n2: n2), NG(ng: a3, n1: n3))

    let b = NG8(a12: 1, a1: 0, a2: 0, a: 0, b12: 0, b1: 0, b2: 0, b: 1)
    let b1 = R2cf(n1: 13, n2: 11)
    let b2 = R2cf(n1: 22, n2: 7)
    test(desc: "[1;5,2] * [3;7]", cfs: NG(ng: b, n1: b1, n2: b2), R2cf(n1: 286, n2: 77))

    let c = NG8(a12: 0, a1: 1, a2: -1, a: 0, b12: 0, b1: 0, b2: 0, b: 1)
    let c1 = R2cf(n1: 13, n2: 11)
    let c2 = R2cf(n1: 22, n2: 7)
    test(desc: "[1;5,2] - [3;7]", cfs: NG(ng: c, n1: c1, n2: c2), R2cf(n1: -151, n2: 77))

    let d = NG8(a12: 0, a1: 1, a2: 0, a: 0, b12: 0, b1: 0, b2: 1, b: 0)
    let d1 = R2cf(n1: 22 * 22, n2: 7 * 7)
    let d2 = R2cf(n1: 22, n2: 7)
    test(desc: "Divide [] by [3;7]", cfs: NG(ng: d, n1: d1, n2: d2))

    let na = NG8(a12: 0, a1: 1, a2: 1, a: 0, b12: 0, b1: 0, b2: 0, b: 1)
    let a1 = R2cf(n1: 2, n2: 7)
    let a2 = R2cf(n1: 13, n2: 11)
    let aa = NG(ng: na, n1: a1, n2: a2)

    let nb = NG8(a12: 0, a1: 1, a2: -1, a: 0, b12: 0, b1: 0, b2: 0, b: 1)
    let b3 = R2cf(n1: 2, n2: 7)
    let b4 = R2cf(n1: 13, n2: 11)
    let bb = NG(ng: nb, n1: b3, n2: b4)

    let nc = NG8(a12: 1, a1: 0, a2: 0, a: 0, b12: 0, b1: 0, b2: 0, b: 1)
    let desc = "([0;3,2] + [1;5,2]) * ([0;3,2] - [1;5,2])"
    test(desc: desc, cfs: NG(ng: nc, n1: aa, n2: bb), R2cf(n1: -7797, n2: 5929))
}

main()

