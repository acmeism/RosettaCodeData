import "/math" for Int
import "/sort" for Sort
import "/fmt" for Fmt

var maxSum = 99

var descendants = List.filled(maxSum + 1, null)
var ancestors   = List.filled(maxSum + 1, null)
for (i in 0..maxSum) {
    descendants[i] = []
    ancestors[i]   = []
}
var primes = Int.primeSieve(maxSum)
for (p in primes) {
    descendants[p].add(p)
    for (s in 1...descendants.count - p) {
        descendants[s + p].addAll(descendants[s].map { |d| p * d })
    }
}
for (p in primes + [4]) descendants[p].removeAt(-1)
var total = 0
for (s in 1..maxSum) {
    Sort.quick(descendants[s])
    total = total + descendants[s].count
    for (d in descendants[s]) {
        if (d > maxSum) break
         ancestors[d] = ancestors[s] + [s]
    }
    if (s < 21 || s == 46 || s == 74 || s == maxSum) {
        Fmt.write("$2d: $d Ancestors[s]: $-18n", s, ancestors[s].count, ancestors[s])
        var count = descendants[s].count
        var desc10 = (count <= 10) ? descendants[s] : descendants[s].take(10).toList + ["..."]
        Fmt.print("$5d Descendants[s]: $n", count, desc10)
    }
}
System.print("\nTotal descendants %(total)")
