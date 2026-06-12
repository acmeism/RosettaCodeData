import "./big" for BigInt
import "./seq" for Lst
import "./fmt" for Fmt

var divisors = Fn.new { |n|
    var factors = BigInt.primeFactors(n)
    var divs = [BigInt.one]
    for (p in factors) {
        for (i in 0...divs.count) divs.add(divs[i]*p)
    }
    return Lst.prune(divs.sort { |i, j| i >= j })
}

var zs = Fn.new { |n, a, b|
    a = BigInt.new(a)
    b = BigInt.new(b)
    var dn = a.pow(n) - b.pow(n)
    if (dn.isPrime) return dn
    var divs = divisors.call(dn)
    var dms = (1...n).map { |m| a.pow(m) - b.pow(m) }.toList
    for (div in divs) {
        if (dms.all { |dm| BigInt.gcd(dm, div) == 1 }) return div
    }
    return BigInt.one
}

var abs = [ [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [3, 2], [5, 3], [7, 3], [7, 5] ]
var lim = 20
for (ab in abs) {
    var a = ab[0]
    var b = ab[1]
    System.print("Zsigmony(n, %(a), %(b)) - first %(lim) terms:")
    Fmt.print("$i", (1..lim).map { |n| zs.call(n, a, b) }.toList)
    System.print()
}
