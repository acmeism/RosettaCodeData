import "./math" for Int
import "./fmt" for Fmt

var max = 1000
var sieved = Int.primeSieve(3*max, false) // includes composites
var p = Int.primeSieve(max, true)         // primes only

var strangePrimes = Fn.new { |n, countOnly|
    var c = 0
    var m = 0
    while (m < p.count && p[m] <= n) m = m + 1
    var r
    var s
    for (i in 1...m-2) {
        for (j in i+1...m-1) {
            r = p[i] + p[j]
            for (k in j+1...m) {
                if (!sieved[s = r + p[k]]) {
                    c = c + 1
                    if (!countOnly) Fmt.print("$2d: $2d + $2d + $2d = $2d", c, p[i], p[j], p[k], s)
                }
            }
        }
    }
    return c
}

System.print("Unique prime triples under 30 which sum to a prime:")
strangePrimes.call(29, false)
var c = strangePrimes.call(999, true)
Fmt.print("\nThere are $,d unique prime triples under 1,000 which sum to a prime.", c)
