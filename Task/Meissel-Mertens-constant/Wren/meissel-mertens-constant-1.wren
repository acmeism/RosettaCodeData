import "./math" for Int
import "./fmt" for Fmt

var euler = 0.57721566490153286
var primes = Int.primeSieve(2.pow(31))
var pc = primes.count
var sum = 0
var c = 0
System.print("Primes added         M")
System.print("------------  --------------")
for (p in primes) {
    var rp = 1/p
    sum = (1-rp).log + rp + sum
    c = c + 1
    if ((c % 1e7) == 0 || c == pc) Fmt.print("$,11d   $0.12f", c, sum + euler)
}
