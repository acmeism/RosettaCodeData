import "./math" for Int
import "./fmt" for Fmt

var zs = Fn.new { |n, a, b|
    var dn = a.pow(n) - b.pow(n)
    if (Int.isPrime(dn)) return dn
    var divs = Int.divisors(dn)
    var dms = (1...n).map { |m| a.pow(m) - b.pow(m) }.toList
    for (i in divs.count-1..1) {
        if (dms.all { |dm| Int.gcd(dm, divs[i]) == 1 }) return divs[i]
    }
    return 1
}

var abs = [ [2, 1], [3, 1], [4, 1], [5, 1], [6, 1], [7, 1], [3, 2], [5, 3], [7, 3], [7, 5] ]
for (ab in abs) {
    var a = ab[0]
    var b = ab[1]
    var lim = 20
    if (a == 7 && b != 3) lim = 18
    System.print("Zsigmony(n, %(a), %(b)) - first %(lim) terms:")
    Fmt.print("$d", (1..lim).map { |n| zs.call(n, a, b) }.toList)
    System.print()
}
