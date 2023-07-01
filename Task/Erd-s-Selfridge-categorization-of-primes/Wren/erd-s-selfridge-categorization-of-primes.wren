import "./math" for Int
import "./fmt" for Fmt

var limit = (1e6.log * 1e6 * 1.2).floor  // should be more than enough
var primes = Int.primeSieve(limit)

var prevCats = {}

var cat // recursive
cat = Fn.new { |p|
    if (prevCats.containsKey(p)) return prevCats[p]
    var pf = Int.primeFactors(p+1)
    if (pf.all { |f| f == 2 || f == 3 }) return 1
    if (p > 2) {
        for (i in pf.count-1..1) {
            if (pf[i-1] == pf[i]) pf.removeAt(i)
        }
    }
    for (c in 2..11) {
        if (pf.all { |f| cat.call(f) < c }) {
            prevCats[p] = c
            return c
        }
    }
    return 12
}

var es = List.filled(12, null)
for (i in 0..11) es[i] = []

System.print("First 200 primes:\n ")
for (p in primes[0..199]) {
    var c = cat.call(p)
    es[c-1].add(p)
}
for (c in 1..6) {
    if (es[c-1].count > 0) {
        System.print("Category %(c):")
        System.print(es[c-1])
        System.print()
    }
}

System.print("First million primes:\n")
for (p in primes[200...1e6]) {
    var c = cat.call(p)
    es[c-1].add(p)
}
for (c in 1..12) {
    var e = es[c-1]
    if (e.count > 0) {
        Fmt.print("Category $-2d: First = $7d  Last = $8d  Count = $6d", c, e[0], e[-1], e.count)
    }
}
