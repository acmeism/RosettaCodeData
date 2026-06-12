import "./fmt" for Fmt

// Highest power of two that divides a given number.
var hpo2 = Fn.new { |n| n & (-n) }

// Base 2 logarithm of the highest power of 2 dividing a given number.
var lhpo2 = Fn.new { |n|
    var q = 0
    var m = hpo2.call(n)
    while (m%2 == 0) {
        m = m >> 1
        q = q + 1
    }
    return q
}

// nim-sum of two numbers.
var nimsum = Fn.new { |x, y| x ^ y }

// nim-product of two numbers.
var nimprod // recursive
nimprod = Fn.new { |x, y|
    if (x < 2 || y < 2) return x * y
    var h = hpo2.call(x)
    System.write("") // fixes VM recursion bug
    if (x > h) return nimprod.call(h, y) ^ nimprod.call(x ^ h, y) // break x into powers of 2
    if (hpo2.call(y) < y) return nimprod.call(y, x) // break y into powers of 2
    var xp = lhpo2.call(x)
    var yp = lhpo2.call(y)
    var comp = xp & yp
    if (comp == 0) return x * y // no Fermat power in common
    h = hpo2.call(comp)
    // a Fermat number square is its sequimultiple
    return nimprod.call(nimprod.call(x >> h, y >> h), 3 << (h-1))
}

var fns = [[nimsum, "⊕"], [nimprod, "⊗"]]
for (fn in fns) {
    System.write(" %(fn[1]) |")
    for (i in 0..15) System.write(Fmt.d(3, i))
    System.print("\n---+%("-" * 48)")
    for (i in 0..15) {
        System.write("%(Fmt.d(2, i)) |")
        for (j in 0..15) System.write(Fmt.d(3, fn[0].call(i, j)))
        System.print()
    }
    System.print()
}
var a = 21508
var b = 42689
System.print("%(a) + %(b) = %(nimsum.call(a, b))")
System.print("%(a) * %(b) = %(nimprod.call(a, b))")
