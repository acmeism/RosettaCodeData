import "./big" for BigInt, BigRat

var toEgyptianHelper // recursive
toEgyptianHelper = Fn.new { |n, d, fracs|
    if (n == BigInt.zero) return
    var divRem = d.divMod(n)
    var div = divRem[0]
    if (divRem[1] > BigInt.zero) div = div.inc
    fracs.add(BigRat.new(BigInt.one, div))
    var n2 = (-d) % n
    if (n2 < BigInt.zero) n2 = n2 + n
    var d2 = d * div
    var f = BigRat.new(n2, d2)
    if (f.num == BigInt.one) {
        fracs.add(f)
        return
    }
    toEgyptianHelper.call(f.num, f.den, fracs)
}

var toEgyptian = Fn.new { |r|
    if (r.num == BigInt.zero) return [r]
    var fracs = []
    if (r.num.abs >= r.den.abs) {
        var div = BigRat.new(r.num/r.den, BigInt.one)
        var rem = r - div
        fracs.add(div)
        toEgyptianHelper.call(rem.num, rem.den, fracs)
    } else {
        toEgyptianHelper.call(r.num, r.den, fracs)
    }
    return fracs
}

BigRat.showAsInt = true
var fracs = [BigRat.new(43, 48), BigRat.new(5, 121), BigRat.new(2014, 59)]
for (frac in fracs) {
    var list = toEgyptian.call(frac)
    System.print("%(frac) -> %(list.join(" + "))")
}

for (r in [98, 998]) {
    if (r == 98) {
        System.print("\nFor proper fractions with 1 or 2 digits:")
    } else {
        System.print("\nFor proper fractions with 1, 2 or 3 digits:")
    }
    var maxSize = 0
    var maxSizeFracs = []
    var maxDen = BigInt.zero
    var maxDenFracs = []
    var sieve = List.filled(r + 1, null) // to eliminate duplicates
    for (i in 0..r) sieve[i] = List.filled(r + 2, false)
    for (i in 1..r) {
        for (j in (i + 1)..(r + 1)) {
            if (!sieve[i][j]) {
                var f = BigRat.new(i, j)
                var list = toEgyptian.call(f)
                var listSize = list.count
                if (listSize > maxSize) {
                    maxSize = listSize
                    maxSizeFracs.clear()
                    maxSizeFracs.add(f)
                } else if (listSize == maxSize) {
                    maxSizeFracs.add(f)
                }
                var listDen = list[-1].den
                if (listDen > maxDen) {
                    maxDen = listDen
                    maxDenFracs.clear()
                    maxDenFracs.add(f)
                } else if (listDen == maxDen) {
                    maxDenFracs.add(f)
                }
                if (i < r / 2) {
                    var k = 2
                    while (true) {
                        if (j * k > r + 1) break
                        sieve[i * k][j * k] = true
                        k = k + 1
                    }
                }
            }
        }
    }
    System.print("  largest number of items = %(maxSize)")
    System.print("  fraction(s) with this number : %(maxSizeFracs)")
    var md = maxDen.toString
    System.write("  largest denominator = %(md.count) digits, ")
    System.print("%(md[0...20])...%(md[-20..-1])")
    System.print("  fraction(s) with this denominator : %(maxDenFracs)")
}
