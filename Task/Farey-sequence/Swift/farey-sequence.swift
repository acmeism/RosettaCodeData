class Farey {
    let n: Int

    init(_ x: Int) {
        n = x
    }

    //using algorithm from wikipedia
    var sequence: [(Int,Int)] {
        var a = 0
        var b = 1
        var c = 1
        var d = n
        var results = [(a, b)]
        while c <= n {
            let k = (n + b) / d
            let oldA = a
            let oldB = b
            a = c
            b = d
            c = k * c - oldA
            d = k * d - oldB
            results += [(a, b)]
        }
        return results
    }

    var formattedSequence: String {
        var s = "\(n):"
        for pair in sequence {
            s += " \(pair.0)/\(pair.1)"
        }
        return s
    }

}

print("Sequences\n")

for n in 1...11 {
    print(Farey(n).formattedSequence)
}

print("\nSequence Lengths\n")

for n in 1...10 {
    let m = n * 100
    print("\(m): \(Farey(m).sequence.count)")
}
