import "./math" for Int
import "./fmt" for Fmt

var limit = 1e9 - 1
var primes = Int.primeSieve(limit)
var maxI = 0
var maxDiff = 0
var nextStop = 10
System.print("The largest differences between adjacent primes under the following limits is:")
for (i in 1...primes.count) {
    var diff = primes[i] - primes[i-1]
    if (diff > maxDiff) {
        maxDiff = diff
        maxI = i
    }
    if (i == primes.count - 1 || primes[i+1] > nextStop)  {
        Fmt.print("Under $,d: $,d - $,d = $,d", nextStop, primes[maxI], primes[maxI-1], maxDiff)
        nextStop = nextStop * 10
    }
}
