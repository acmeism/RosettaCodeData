import "./math" for Int
import "./fmt" for Fmt

var primes = Int.primeSieve(1e7 + 19) // next prime above 10 million
var strong = []
var weak = []
for (p in 1...primes.count-1) {
    if (primes[p] > (primes[p-1] + primes[p+1]) / 2) {
        strong.add(primes[p])
    } else if (primes[p] < (primes[p-1] + primes[p+1]) / 2) {
        weak.add(primes[p])
    }
}

System.print("The first 36 strong primes are:")
Fmt.print("$d", strong.take(36))
Fmt.print("\nThe count of the strong primes below $,d is $,d.", 1e6, strong.count{ |n| n < 1e6 })
Fmt.print("\nThe count of the strong primes below $,d is $,d.", 1e7, strong.count{ |n| n < 1e7 })

System.print("\nThe first 37 weak primes are:")
Fmt.print("$d", weak.take(37))
Fmt.print("\nThe count of the weak primes below $,d is $,d.", 1e6, weak.count{ |n| n < 1e6 })
Fmt.print("\nThe count of the weak primes below $,d is $,d.", 1e7, weak.count{ |n| n < 1e7 })
