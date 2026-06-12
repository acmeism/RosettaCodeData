import "./math" for Int
import "./fmt" for Fmt

var primes = Int.primeSieve(14999)
System.print("Cubic special primes under 15,000:")
System.print(" Prime1  Prime2    Gap  Cbrt")
var lastCubicSpecial = 3
var gap = 1
var count = 1
Fmt.print("$,7d $,7d $,6d $4d", 2, 3, 1, 1)
for (p in primes.skip(2)) {
    gap = p - lastCubicSpecial
    if (Int.isCube(gap)) {
        Fmt.print("$,7d $,7d $,6d $4d", lastCubicSpecial, p, gap, gap.cbrt.truncate)
        lastCubicSpecial = p
        count = count + 1
    }
}
System.print("\n%(count+1) such primes found.")
