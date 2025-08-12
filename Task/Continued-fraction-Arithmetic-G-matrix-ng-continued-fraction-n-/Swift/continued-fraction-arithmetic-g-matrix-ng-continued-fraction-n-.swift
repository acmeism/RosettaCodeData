protocol IteratorTrait {
    func hasNext() -> Bool
    func next() -> Int
}

struct CFData {
    let text: String
    let args: [Int]
    let iterator: IteratorTrait
}

class R2cfIterator: IteratorTrait {
    var numerator: Int
    var denominator: Int

    init(numerator: Int, denominator: Int) {
        self.numerator = numerator
        self.denominator = denominator
    }

    func hasNext() -> Bool {
        return denominator != 0
    }

    func next() -> Int {
        let div = numerator / denominator
        let rem = numerator % denominator
        numerator = denominator
        denominator = rem
        return div
    }
}

class Root2: IteratorTrait {
    var firstReturn = true

    func hasNext() -> Bool {
        return true
    }

    func next() -> Int {
        if firstReturn {
            firstReturn = false
            return 1
        } else {
            return 2
        }
    }
}

class ReciprocalRoot2: IteratorTrait {
    var firstReturn = true
    var secondReturn = true

    func hasNext() -> Bool {
        return true
    }

    func next() -> Int {
        if firstReturn {
            firstReturn = false
            return 0
        } else if secondReturn {
            secondReturn = false
            return 1
        } else {
            return 2
        }
    }
}

class NG {
    var a1: Int
    var a: Int
    var b1: Int
    var b: Int

    init(args: [Int]) {
        self.a1 = args[0]
        self.a = args[1]
        self.b1 = args[2]
        self.b = args[3]
    }

    func ingress(aN: Int) {
        let temp = a
        a = a1
        a1 = temp + a1 * aN
        let tempB = b
        b = b1
        b1 = tempB + b1 * aN
    }

    func egress() -> Int {
        let n = a / b
        let temp = a
        a = b
        b = temp - b * n
        let tempA1 = a1
        a1 = b1
        b1 = tempA1 - b1 * n
        return n
    }

    func needsTerm() -> Bool {
        return b == 0 || b1 == 0 || a * b1 != a1 * b
    }

    func egressDone() -> Int {
        if needsTerm() {
            a = a1
            b = b1
        }
        return egress()
    }

    func done() -> Bool {
        return b == 0 || b1 == 0
    }
}

func main() {
    let cfData = [
        CFData(text: "[1; 5, 2] + 1 / 2", args: [2, 1, 0, 2], iterator: R2cfIterator(numerator: 13, denominator: 11)),
        CFData(text: "[3; 7] + 1 / 2", args: [2, 1, 0, 2], iterator: R2cfIterator(numerator: 22, denominator: 7)),
        CFData(text: "[3; 7] divided by 4", args: [1, 0, 0, 4], iterator: R2cfIterator(numerator: 22, denominator: 7)),
        CFData(text: "sqrt(2)", args: [0, 1, 1, 0], iterator: Root2()),
        CFData(text: "1 / sqrt(2)", args: [0, 1, 1, 0], iterator: ReciprocalRoot2()),
        CFData(text: "(1 + sqrt(2)) / 2", args: [1, 1, 0, 2], iterator: Root2()),
        CFData(text: "(1 + 1 / sqrt(2)) / 2", args: [1, 1, 0, 2], iterator: ReciprocalRoot2())
    ]

    for data in cfData {
        print("\(data.text) -> ", terminator: "")
        let ng = NG(args: data.args)
        var iterator = data.iterator
        var nextTerm = 0
        for _ in 1...20 {
            if !iterator.hasNext() {
                break
            }
            nextTerm = iterator.next()
            if !ng.needsTerm() {
                print("\(ng.egress()) ", terminator: "")
            }
            ng.ingress(aN: nextTerm)
        }
        while !ng.done() {
            print("\(ng.egressDone()) ", terminator: "")
        }
        print()
    }
}

main()
