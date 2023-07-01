import Foundation

class PadovanRecurrence: Sequence, IteratorProtocol {
    private var p = [1, 1, 1]
    private var n = 0

    func next() -> Int? {
        let pn = n < 3 ? p[n] : p[0] + p[1]
        p[0] = p[1]
        p[1] = p[2]
        p[2] = pn
        n += 1
        return pn
    }
}

class PadovanFloor: Sequence, IteratorProtocol {
    private let P = 1.324717957244746025960908854
    private let S = 1.0453567932525329623
    private var n = 0

    func next() -> Int? {
        let p = Int(floor(pow(P, Double(n - 1)) / S + 0.5))
        n += 1
        return p
    }
}

class PadovanLSystem: Sequence, IteratorProtocol {
    private var str = "A"

    func next() -> String? {
        let result = str
        var next = ""
        for ch in str {
            switch (ch) {
            case "A": next.append("B")
            case "B": next.append("C")
            default: next.append("AB")
            }
        }
        str = next
        return result
    }
}

print("First 20 terms of the Padovan sequence:")
for p in PadovanRecurrence().prefix(20) {
    print("\(p)", terminator: " ")
}
print()

var b = PadovanRecurrence().prefix(64)
    .elementsEqual(PadovanFloor().prefix(64))
print("\nRecurrence and floor functions agree for first 64 terms? \(b)")

print("\nFirst 10 strings produced from the L-system:");
for p in PadovanLSystem().prefix(10) {
    print(p, terminator: " ")
}
print()

b = PadovanLSystem().prefix(32).map{$0.count}
    .elementsEqual(PadovanRecurrence().prefix(32))
print("\nLength of first 32 strings produced from the L-system = Padovan sequence? \(b)")
