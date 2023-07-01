import "./math" for Int
import "./gmp" for Mpz
import "./fmt"for Fmt

var primes = Int.primeSieve(12000)
var sw = ""
var count = 0
var i = 0
var n = Mpz.new()
System.print("The known Smarandache-Wellin primes are:")
while (count < 8) {
    sw = sw + primes[i].toString
    n.setStr(sw)
    if (n.probPrime(15) > 0) {
        count = count + 1
        Fmt.print("$r: index $4d  digits $4d  last prime $5d -> $20a", count, i+1, sw.count, primes[i], n)
    }
    i = i + 1
}

System.print("\nThe first 20 Derived Smarandache-Wellin primes are:")
var freqs = List.filled(10, 0)
count = 0
i = 0
while (count < 20) {
    var p = primes[i].toString
    for (d in p) {
        var n = Num.fromString(d)
        freqs[n] = freqs[n] + 1
    }
    var dsw = freqs.join("").trimStart("0")
    n.setStr(dsw)
    if (n.probPrime(15) > 0) {
        count = count + 1
        Fmt.print("$4r: index $4d  prime $i", count, i+1, n)
    }
    i = i + 1
}
