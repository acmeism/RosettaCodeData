import "./math" for Int
import "./fmt" for Fmt

var limit = 1e5
var results = []
var i = 2
while (i * i < limit) {
    var n = Int.divisors(i * i).count
    if (n > 2 && Int.isPrime(n)) results.add(i * i)
    i = i + 1
}
Fmt.print("Positive integers under $,7d whose number of divisors is an odd prime:", limit)
Fmt.tprint("$,7d", results, 10)
var under1000 = results.count { |r| r < 1000 }
System.print("\nFound %(results.count) such integers (%(under1000) under 1,000).")
