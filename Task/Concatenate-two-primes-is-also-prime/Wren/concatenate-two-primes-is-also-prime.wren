import "./math" for Int
import "./fmt" for Fmt
import "./seq" for Lst

var limit = 99
var primes = Int.primeSieve(limit)
var results = []
for (p in primes) {
    for (q in primes) {
        var pq = (q < 10) ? p*10 + q : p*100 + q
        if (Int.isPrime(pq)) results.add(pq)
    }
}
results = Lst.distinct(results)
results.sort()
System.print("Two primes under 100 concatenated together to form another prime:")
Fmt.tprint("$,6d", results, 10)
System.print("\nFound %(results.count) such concatenated primes.")
