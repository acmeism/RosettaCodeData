import "./math" for Int
import "./fmt" for Fmt

var isSquare = Fn.new { |n|
    var s = n.sqrt.floor
    return s*s == n
}

var primes = Int.primeSieve(15999)
System.print("Quadrat special primes under 16,000:")
System.print(" Prime1  Prime2    Gap  Sqrt")
var lastQuadSpecial = 3
var gap = 1
var count = 1
Fmt.print("$,7d $,7d $,6d $4d", 2, 3, 1, 1)
for (p in primes.skip(2)) {
    gap = p - lastQuadSpecial
    if (isSquare.call(gap)) {
        Fmt.print("$,7d $,7d $,6d $4d", lastQuadSpecial, p, gap, gap.sqrt)
        lastQuadSpecial = p
        count = count + 1
    }
}
System.print("\n%(count+1) such primes found.")
