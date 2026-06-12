import "./big" for BigInt
import "./fmt" for Fmt

// Given non-negative integer n and base b, return hereditary representation
// consisting of tuples (j, k) so sum of all (j * b^(evaluate(k, b)) = n.
var decompose // recursive
decompose = Fn.new { |n, b|
    if (n < b) return n
    var decomp = []
    var e = BigInt.zero
    while (n != 0) {
        var t = n.divMod(b)
        n = t[0]
        var r = t[1]
        if (r > 0) decomp.add([r, decompose.call(e, b)])
        e = e.inc
    }
    return decomp
}

// Evaluate hereditary representation d under base b.
var evaluate // recursive
evaluate = Fn.new { |d, b|
    if (d is BigInt) return d
    var sum = BigInt.zero
    for (a in d) {
        var j = a[0]
        var k = a[1]
        sum = sum + j * b.pow(evaluate.call(k, b))
    }
    return sum
}

// Return a vector of up to limitlength values of the Goodstein sequence for n.
var goodstein = Fn.new { |n, limitLength|
    var seq = []
    var b = BigInt.two
    while (seq.count < limitLength) {
        seq.add(n)
        if (n == 0) break
        var d = decompose.call(n, b)
        b = b.inc
        n = evaluate.call(d, b) - 1
    }
    return seq
}

// Get the nth term of the Goodstein(n) sequence counting from 0
var a266201 = Fn.new { |n| goodstein.call(n, (n + 1).toSmall)[-1] }

System.print("Goodstein(n) sequence (first 10) for values of n in [0, 7]:")
for (i in BigInt.zero..7) System.print("Goodstein of %(i): %(goodstein.call(i, 10))")

System.print("\nThe nth term of Goodstein(n) sequence counting from 0, for values of n in [0, 16]:")
for (i in BigInt.zero..16) {
    Fmt.print("Term $2i of Goodstein($2i): $i", i, i, a266201.call(i, 10))
}
