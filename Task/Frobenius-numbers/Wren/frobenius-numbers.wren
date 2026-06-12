import "./math" for Int
import "./fmt" for Fmt

var primes = Int.primeSieve(101)
var frobenius = []
for (i in 0...primes.count-1) {
    var frob = primes[i]*primes[i+1] - primes[i] - primes[i+1]
    if (frob >= 10000) break
    frobenius.add(frob)
}
System.print("Frobenius numbers under 10,000:")
Fmt.tprint("$,5d", frobenius, 9)
System.print("\n%(frobenius.count) such numbers found.")
