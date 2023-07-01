import "./perm" for Powerset
import "./math" for Int
import "./seq" for Lst
import "./fmt" for Fmt

var ps = Powerset.list((9..1).toList)
var descPrimes = ps.skip(1).map { |s| Num.fromString(s.join()) }
                           .where { |p| Int.isPrime(p) }
                           .toList
                           .sort()
System.print("There are %(descPrimes.count) descending primes, namely:")
for (chunk in Lst.chunks(descPrimes, 10)) Fmt.print("$8s", chunk)
