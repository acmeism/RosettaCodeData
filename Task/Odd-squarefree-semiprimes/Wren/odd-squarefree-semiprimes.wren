import "./math" for Int
import "./fmt" for Fmt

var primes = Int.primeSieve(333)
var oss = []
for (i in 1...primes.count-1) {
    for (j in i + 1...primes.count) {
       var n = primes[i] * primes[j]
       if (n >= 1000) break
       oss.add(n)
    }
}
System.print("Odd squarefree semiprimes under 1,000:")
Fmt.tprint("$3d", oss.sort(), 10)
System.print("\n%(oss.count) such numbers found.")
