import "./math" for Int, Nums
import "./fmt" for Fmt

var primes = Int.primeSieve(1000, true)
var maxSum = Nums.sum(primes)
var c = Int.primeSieve(maxSum, false)
var primeSum = 0
var results = []
for (p in primes) {
   primeSum = primeSum + p
   if (!c[primeSum]) results.add(p)
}
System.print("Primes 'p' under 1000 where the sum of all primes <= p is also prime:")
Fmt.tprint("$4d", results, 7)
System.print("\nFound %(results.count) such primes.")
