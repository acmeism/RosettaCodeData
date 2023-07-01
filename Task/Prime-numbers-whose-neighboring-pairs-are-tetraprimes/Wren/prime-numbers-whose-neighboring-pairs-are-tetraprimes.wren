import "./math" for Int, Nums
import "./sort" for Find
import "./fmt" for Fmt

var primes = Int.primeSieve(1e7)

var isTetraPrime = Fn.new { |n|
    var count = 0
    var prevFact = 1
    for (p in primes) {
        var limit = p * p
        if (count == 0) {
            limit = limit * limit
        } else if (count == 1) {
            limit = limit * p
        }
        if (limit <= n) {
            while (n % p == 0) {
                if (count == 4 || p == prevFact) return false
                count = count + 1
                n = (n/p).floor
                prevFact = p
            }
        } else {
            break
        }
    }
    if (n > 1) {
        if (count == 4 || n == prevFact) return false
        count = count + 1
    }
    return count == 4
}

var highest5 = primes[Find.nearest(primes, 1e5) - 1]
var highest6 = primes[Find.nearest(primes, 1e6) - 1]
var highest7 = primes[-1]
var tetras1 = []
var tetras2 = []
var sevens1 = 0
var sevens2 = 0
var j = 1e5
for (p in primes) {
    // process even numbers first as likely to have most factors
    if (isTetraPrime.call(p-1) && isTetraPrime.call(p-2)) {
        tetras1.add(p)
        if ((p-1)%7 == 0 || (p-2)%7 == 0) sevens1 = sevens1 + 1
    }

    if (isTetraPrime.call(p+1) && isTetraPrime.call(p+2)) {
        tetras2.add(p)
        if ((p+1)%7 == 0 || (p+2)%7 == 0) sevens2 = sevens2 + 1
    }

    if (p == highest5 || p == highest6 || p == highest7) {
        for (i in 0..1) {
            var tetras = (i == 0) ? tetras1 : tetras2
            var sevens = (i == 0) ? sevens1 : sevens2
            var c = tetras.count
            var t = (i == 0) ? "preceding" : "following"
            Fmt.write("Found $,d primes under $,d whose $s neighboring pair are tetraprimes", c, j, t)
            if (p == highest5) {
                Fmt.print(":")
                Fmt.tprint("$5d ", tetras, 10)
            }
            Fmt.print("\nof which $,d have a neighboring pair one of whose factors is 7.\n", sevens)
            var gaps = List.filled(c-1, 0)
            for (k in 0...c-1) gaps[k] = tetras[k+1] - tetras[k]
            gaps.sort()
            var min = gaps[0]
            var max = gaps[-1]
            var med = Nums.median(gaps)
            Fmt.print("Minimum gap between those $,d primes : $,d", c, min)
            Fmt.print("Median  gap between those $,d primes : $,d", c, med)
            Fmt.print("Maximum gap between those $,d primes : $,d", c, max)
            Fmt.print()
        }
        j = j * 10
    }
}
