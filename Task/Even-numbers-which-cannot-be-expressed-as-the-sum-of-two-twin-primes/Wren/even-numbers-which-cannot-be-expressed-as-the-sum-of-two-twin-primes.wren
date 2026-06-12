import "./math" for Int
import "./fmt" for Fmt

var limit = 100000 // say
var primes = Int.primeSieve(limit)[2..-1] // exclude 2 & 3

var twins = [3]
for (i in 0...primes.count-1) {
    if (primes[i+1] - primes[i] == 2) {
        if (twins[-1] != primes[i]) twins.add(primes[i])
        twins.add(primes[i+1])
    }
}

var nonTwinSums = Fn.new {
    var sieve = List.filled(limit+1, false)
    for (i in 0...twins.count) {
        for (j in i...twins.count) {
            var sum = twins[i] + twins[j]
            if (sum > limit) break
            sieve[sum] = true
        }
    }
    var res = []
    var i = 2
    while (i < limit) {
        if (!sieve[i]) res.add(i)
        i = i + 2
    }
    return res
}

System.print("Non twin prime sums:")
var ntps = nonTwinSums.call()
Fmt.tprint("$4d", ntps, 10)
System.print("Found %(ntps.count)")

System.print("\nNon twin prime sums (including 1):")
twins.insert(0, 1)
ntps = nonTwinSums.call()
Fmt.tprint("$4d", ntps, 10)
System.print("Found %(ntps.count)")
