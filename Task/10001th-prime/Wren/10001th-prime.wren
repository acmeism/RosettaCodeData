import "./math" for Int
import "./fmt" for Fmt

var n = 10001
var limit = (n.log * n * 1.2).floor  // should be enough
var primes = Int.primeSieve(limit)
Fmt.print("The $,r prime is $,d.", n, primes[n-1])
