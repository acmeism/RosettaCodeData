import "./long" for Long, ULong

class BT {
    static forward(a) {
        var c = a.count
        var b = List.filled(c, null)
        for (n in 0...c) {
            b[n] = Long.zero
            for (k in 0..n) b[n] = b[n] + ULong.binomial(n, k).toLong * a[k]
        }
        return b
    }

    static inverse(b) {
        var c = b.count
        var a = List.filled(c, null)
        for (n in 0...c) {
            a[n] = Long.zero
            for (k in 0..n) {
                var sign = ((n - k) % 2 == 0) ? 1 : -1
                a[n] = a[n] + ULong.binomial(n, k).toLong * b[k] * sign
            }
        }
        return a
    }

    static selfInverting(a) {
        var c = a.count
        var b = List.filled(c, null)
        for (n in 0...c) {
            b[n] = Long.zero
            for (k in 0..n) {
                var sign = k % 2 == 0 ? 1 : -1
                b[n] = b[n] + ULong.binomial(n, k).toLong * a[k] * sign
            }
        }
        return b
    }
}

var seqs = [
    [1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845, 35357670, 129644790, 477638700, 1767263190],
    [0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
    [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181],
    [1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37]
]

var names = [
    "Catalan number sequence:",
    "Prime flip-flop sequence:",
    "Fibonacci number sequence:",
    "Padovan number sequence:"
]

var saved
for (i in 0...seqs.count) {
    System.print(names[i])
    System.print(seqs[i].join(" "))
    System.print("Forward binomial transform:")
    System.print((saved = BT.forward(seqs[i])).join(" "))
    System.print("Inverse binomial transform:")
    System.print(BT.inverse(seqs[i]).join(" "))
    System.print("Round trip:")
    System.print(BT.inverse(saved).join(" "))
    System.print("Self-inverting:")
    System.print((saved = BT.selfInverting(seqs[i])).join(" "))
    System.print("Re-inverted:")
    System.print(BT.selfInverting(saved).join(" "))
    if (i < seqs.count - 1) System.print()
}
