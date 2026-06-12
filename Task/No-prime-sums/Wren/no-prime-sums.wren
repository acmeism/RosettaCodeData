import "./math" for Int
import "./ordered" for OrderedSet

var BOTH = 0
var ODD  = 1
var EVEN = 2

var kinds = ["", "odd ", "even "]

var c = Int.primeSieve(1e8, false)

var noPrimeSums = Fn.new { |start, limit, kind|
    var step = kind == BOTH ? 1 : 2
    var k = kind == EVEN ? 2 : 3
    var sums = OrderedSet.new()
    sums.add(0)
    sums.add(start)
    var res = [start]
    while (res.count < limit) {
        while (sums.any { |s| !c[k + s] }) k = k + step
        if (kind == BOTH ||
           (kind == ODD  && k % 2 == 1) ||
           (kind == EVEN && k % 2 == 0) ){
            var extra = sums.map { |s| k + s }.toList
            sums.addAll(extra)
            res.add(k)
        }
        k = k + step
    }
    return res
}

var LIMIT = 10
System.print("Sequence, starting with 1, then:")
for (kind in [BOTH, ODD, EVEN]) {
    System.print("\nlexicographically earliest %(kinds[kind])integer such that no subsequence sums to a prime:")
    System.print(noPrimeSums.call(1, LIMIT, kind))
}
