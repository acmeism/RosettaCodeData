import "./math" for Int
import "./seq" for Lst
import "./fmt" for Fmt

var primes = Int.primeSieve(1e7-1)

var getBrilliant = Fn.new { |digits, limit, countOnly|
    var brilliant = []
    var count = 0
    var pow = 1
    var next = Num.maxSafeInteger
    for (k in 1..digits) {
        var s = primes.where { |p| p > pow && p < pow * 10 }.toList
        for (i in 0...s.count) {
            for (j in i...s.count) {
                var prod = s[i] * s[j]
                if (prod < limit) {
                    if (countOnly) {
                        count = count + 1
                    } else {
                        brilliant.add(prod)
                    }
                } else {
                    next = next.min(prod)
                    break
                }
            }
        }
        pow = pow * 10
    }
    return countOnly ? [count, next] : [brilliant, next]
}

System.print("First 100 brilliant numbers:")
var brilliant = getBrilliant.call(2, 10000, false)[0]
brilliant.sort()
brilliant = brilliant[0..99]
for (chunk in Lst.chunks(brilliant, 10)) Fmt.print("$4d", chunk)
System.print()
for (k in 1..12) {
    var limit = 10.pow(k)
    var res = getBrilliant.call(k, limit, true)
    var total = res[0]
    var next = res[1]
    Fmt.print("First >= $,17d is $,15r in the series: $,17d", limit, total + 1, next)
}
