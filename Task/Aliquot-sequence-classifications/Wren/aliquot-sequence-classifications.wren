import "/fmt" for Conv, Fmt
import "/math" for Int, Nums
import "/seq" for Lst

class Classification {
    construct new(seq, aliquot) {
        _seq = seq
        _aliquot = aliquot
    }
    seq { _seq}
    aliquot { _aliquot }
}

var THRESHOLD = 2.pow(47)

var classifySequence = Fn.new { |k|
    if (k <= 0) Fiber.abort("K must be positive")
    var last = k
    var seq = [k]
    while (true) {
        last = Nums.sum(Int.properDivisors(last))
        seq.add(last)
        var n = seq.count
        var aliquot =
            (last == 0) ? "Terminating" :
            (n == 2 && last == k) ? "Perfect" :
            (n == 3 && last == k) ? "Amicable" :
            (n >= 4 && last == k) ? "Sociable[%(n-1)]" :
            (last == seq[n-2]) ? "Aspiring" :
            (n > 3 && seq[1..n-3].contains(last)) ? "Cyclic[%(n-1-Lst.indexOf(seq, last))]" :
            (n == 16 || last > THRESHOLD) ? "Non-terminating" : ""
        if (aliquot != "") return Classification.new(seq, aliquot)
    }
}

System.print("Aliquot classifications - periods for Sociable/Cyclic in square brackets:\n")
for (k in 1..10) {
    var c = classifySequence.call(k)
    System.print("%(Fmt.d(2, k)): %(Fmt.s(-15, c.aliquot)) %(c.seq)")
}

System.print()
var a = [11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488]
for (k in a) {
    var c = classifySequence.call(k)
    System.print("%(Fmt.d(7, k)): %(Fmt.s(-15, c.aliquot)) %(c.seq)")
}

System.print()
var k = 15355717786080
var c = classifySequence.call(k)
var seq = c.seq.map { |i| Conv.dec(i) }.toList // ensure 15 digit integer is printed in full
System.print("%(k): %(Fmt.s(-15, c.aliquot)) %(seq)")
