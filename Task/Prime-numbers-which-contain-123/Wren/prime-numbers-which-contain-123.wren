import "./math" for Int
import "./fmt" for Fmt

var limit = 1e5
var primes = Int.primeSieve(limit * 10).where { |p| p > 999 }
var results = primes.where { |p| p < limit && p.toString.contains("123") }.toList
Fmt.print("Primes under $,d which contain '123' when expressed in decimal:", limit)
Fmt.tprint("$,7d", results, 10)
Fmt.print("\nFound $,d such primes under $,d.", results.count, limit)

limit = 1e6
var count = primes.count { |p| p.toString.contains("123") }
Fmt.print("\nFound $,d such primes under $,d.", count, limit)
