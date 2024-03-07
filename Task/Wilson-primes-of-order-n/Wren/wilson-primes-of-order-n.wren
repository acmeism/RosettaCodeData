import "./math" for Int
import "./big" for BigInt
import "./fmt" for Fmt

var limit = 11000
var primes = Int.primeSieve(limit)
var facts = List.filled(limit, null)
facts[0] = BigInt.one
for (i in 1...11000) facts[i] = facts[i-1] * i
var sign = 1
System.print(" n:  Wilson primes")
System.print("--------------------")
for (n in 1..11) {
    Fmt.write("$2d:  ", n)
    sign = -sign
    for (p in primes) {
        if (p < n) continue
        var f = facts[n-1] * facts[p-n] - sign
        if (f.isDivisibleBy(p*p)) Fmt.write("%(p) ", p)
    }
    System.print()
}
