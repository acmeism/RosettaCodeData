import "./big" for BigInt
import "./fmt" for Fmt

// Only valid for n > 0 && base >= 2
var mult = Fn.new { |n, base|
    var m = BigInt.one
    while (m > BigInt.zero && n > BigInt.zero) {
        var dm = n.divMod(base)
        m = m * dm[1]
        n = dm[0]
    }
    return m
}

// Only valid for n >= 0 && base >= 2
var multDigitalRoot = Fn.new { |n, base|
    base = BigInt.new(base)
    var m = n.copy()
    var mp = BigInt.zero
    while (m >= base) {
        m = mult.call(m, base)
        mp = mp.inc
    }
    return [mp, m.toSmall]
}

var base = 10
var size = 5

var tests = [
    123321, 7739, 893, 899998,"18446743999999999999", 3778888999, "277777788888899"
]

var testFmt = "$20s $3s $3s"
Fmt.print(testFmt, "Number", "MDR", "MP")
for (test in tests) {
    var n = BigInt.new(test)
    var mpdr = multDigitalRoot.call(n, base)
    Fmt.print(testFmt, n, mpdr[1], mpdr[0])
}
System.print()

var list = List.filled(base, null)
for (i in 0...base) list[i] = []
var cnt = size * base
var n = BigInt.zero
while (cnt > 0) {
    var mpdr = multDigitalRoot.call(n, base)
    var mdr = mpdr[1]
    if (list[mdr].count < size) {
        list[mdr].add(n)
        cnt = cnt - 1
    }
    n = n.inc
}
Fmt.print("$3s: $s", "MDR", "First")
var i = 0
for (l in list) {
    Fmt.print("$3d: $s", i, l.toString)
    i = i + 1
}
