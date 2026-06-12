import "./iterate" for Stepped
import "./fmt" for Fmt

var count

var primeCounter = Fn.new { |limit|
    count = List.filled(limit, 1)
    if (limit > 0) count[0] = 0
    if (limit > 1) count[1] = 0
    for (i in Stepped.new(4...limit, 2)) count[i] = 0
    var p = 3
    var sq = 9
    while (sq < limit) {
        if (count[p] != 0) {
            var q = sq
            while (q < limit) {
                count[q] = 0
                q = q + p * 2
            }
        }
        sq = sq + (p + 1) * 4
        p = p + 2
    }
    var sum = 0
    for (i in 0...limit) {
        sum = sum + count[i]
        count[i] = sum
    }
}

var primeCount = Fn.new { |n| (n < 1) ? 0 : count[n] }

var ramanujanMax = Fn.new { |n| (4 * n * (4*n).log).ceil }

var ramanujanPrime = Fn.new { |n|
    if (n == 1) return 2
    for (i in ramanujanMax.call(n)..2*n) {
        if (i % 2 == 1) continue
        if (primeCount.call(i) - primeCount.call((i/2).floor) < n) return i + 1
    }
    return 0
}

primeCounter.call(1 + ramanujanMax.call(1e6))
System.print("The first 100 Ramanujan primes are:")
var rams = (1..100).map { |n| ramanujanPrime.call(n) }
Fmt.tprint("$,5d", rams, 10)

Fmt.print("\nThe 1,000th Ramanujan prime is $,6d", ramanujanPrime.call(1000))

Fmt.print("\nThe 10,000th Ramanujan prime is $,7d", ramanujanPrime.call(10000))

Fmt.print("\nThe 100,000th Ramanujan prime is $,9d", ramanujanPrime.call(100000))

Fmt.print("\nThe 1,000,000th Ramanujan prime is $,10d", ramanujanPrime.call(1000000))
