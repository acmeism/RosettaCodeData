import "./math" for Int
import "./fmt" for Fmt

var limit = (1e7.log * 1e7 * 1.2).floor  // should be more than enough
var primes = Int.primeSieve(limit)
System.print("The first 20 pairs of natural numbers whose sum is prime are:")
for (i in 1..20) {
    var p = primes[i]
    var hp = (p/2).floor
    Fmt.print("$2d + $2d = $2d", hp, hp + 1, p)
}
System.print("\nThe 10 millionth such pair is:")
var p = primes[1e7]
var hp = (p/2).floor
Fmt.print("$2d + $2d = $2d", hp, hp + 1, p)
