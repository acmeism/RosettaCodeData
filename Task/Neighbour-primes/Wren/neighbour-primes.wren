import "./math" for Int
import "./fmt" for Fmt

var primes = Int.primeSieve(504)
var nprimes = []
System.print("Neighbour primes < 500:")
for (i in 0...primes.count-1) {
    var p = primes[i] * primes[i+1] + 2
    if (Int.isPrime(p)) nprimes.add(primes[i])
}
Fmt.tprint("$3d", nprimes, 10)
System.print("\nFound %(nprimes.count) such primes.")
