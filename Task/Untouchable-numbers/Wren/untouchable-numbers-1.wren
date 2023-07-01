import "/math" for Int, Nums
import "/seq" for Lst
import "/fmt" for Fmt

var sieve = Fn.new { |n|
    n = n + 1
    var s = List.filled(n+1, false)
    for (i in 0..n) {
        var sum = Nums.sum(Int.properDivisors(i))
        if (sum <= n) s[sum] = true
    }
    return s
}

var limit = 1e5
var c = Int.primeSieve(limit, false)
var s = sieve.call(14 * limit)
var untouchable = [2, 5]
var n = 6
while (n <= limit) {
    if (!s[n] && c[n-1] && c[n-3]) untouchable.add(n)
    n = n + 2
}

System.print("List of untouchable numbers <= 2,000:")
for (chunk in Lst.chunks(untouchable.where { |n| n <= 2000 }.toList, 10)) {
    Fmt.print("$,6d", chunk)
}
System.print()
Fmt.print("$,6d untouchable numbers were found  <=   2,000", untouchable.count { |n| n <= 2000 })
var p = 10
var count = 0
for (n in untouchable) {
    count = count + 1
    if (n > p) {
        Fmt.print("$,6d untouchable numbers were found  <= $,7d", count-1, p)
        p = p * 10
        if (p == limit) break
    }
}
Fmt.print("$,6d untouchable numbers were found  <= $,d", untouchable.count, limit)
