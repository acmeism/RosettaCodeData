import "./iterate" for Stepped, Indexed
import "./math" for Int, Math
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
    for (i in ramanujanMax.call(n)..2) {
        if (i % 2 == 1) continue
        if (primeCount.call(i) - primeCount.call((i/2).floor) < n) return i + 1
    }
    return 0
}

var rpc = Fn.new { |p| primeCount.call(p) - primeCount.call((p/2).floor) }

for (limit in [1e5, 1e6]) {
    var start = System.clock
    primeCounter.call(1 + ramanujanMax.call(limit))
    var rplim = ramanujanPrime.call(limit)
    Fmt.print("The $,dth Ramanujan prime is $,d", limit, rplim)
    var r = Int.primeSieve(rplim)
    var c = r.map { |p| rpc.call(p) }.toList
    var ok = c[-1]
    for (i in c.count - 2..0) {
        if (c[i] < ok) {
            ok = c[i]
        } else {
            c[i] = 0
        }
    }
    var ir = Indexed.new(r).where { |se| c[se.index] != 0 }.toList
    var twins = 0
    for (i in 0...ir.count-1) {
        if (ir[i].value + 2 == ir[i+1].value) twins = twins + 1
    }
    Fmt.print("There are $,d twins in the first $,d Ramanujan primes.", twins, limit)
    System.print("Took %(Math.toPlaces(System.clock - start, 2, 0)) seconds.\n")
}
