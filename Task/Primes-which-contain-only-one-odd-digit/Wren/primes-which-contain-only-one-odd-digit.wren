import "./math" for Int
import "./fmt" for Fmt

var limit = 999
var maxDigits = 3
var primes = Int.primeSieve(limit)
var results = []
for (prime in primes.skip(1)) {
    if (Int.digits(prime)[0...-1].all { |d| d & 1 == 0 }) results.add(prime)
}
Fmt.print("Primes under $,d which contain only one odd digit:", limit + 1)
Fmt.tprint("$,%(maxDigits)d", results, 9)
System.print("\nFound %(results.count) such primes.\n")

limit = 1e9 - 1
primes = Int.primeSieve(limit)
var count = 0
var pow = 10
for (prime in primes.skip(1)) {
    if (Int.digits(prime)[0...-1].all { |d| d & 1 == 0 }) count = count + 1
    if (prime > pow) {
        Fmt.print("There are $,7d such primes under $,d", count, pow)
        pow = pow * 10
    }
}
Fmt.print("There are $,7d such primes under $,d", count, pow)
