import "./math" for Int
import "./fmt" for Fmt

var limit = 1e9
var maxIndex = 8
var primes = Int.primeSieve(limit)
var anaprimes = {}
for (p in primes) {
    var digs = Int.digits(p)
    var key = 1
    for (dig in digs) key = key * primes[dig]
    if (anaprimes.containsKey(key)) {
        anaprimes[key].add(p)
    } else {
        anaprimes[key] = [p]
    }
}
var largest = List.filled(maxIndex + 1, 0)
var groups = List.filled(maxIndex + 1, null)
for (key in anaprimes.keys) {
    var v = anaprimes[key]
    var nd = Int.digits(v[0]).count
    var c = v.count
    if (c > largest[nd-1]) {
        largest[nd-1] = c
        groups[nd-1] = [v]
    } else if (c == largest[nd-1]) {
        groups[nd-1].add(v)
    }
}
var j = 1000
for (i in 2..maxIndex) {
    Fmt.print("Largest group(s) of anaprimes before $,d: $,d members:", j, largest[i])
    groups[i].sort { |a, b| a[0] < b[0] }
    for (g in groups[i]) Fmt.print("  First: $,d  Last: $,d", g[0], g[-1])
    j = j * 10
    System.print()
}
