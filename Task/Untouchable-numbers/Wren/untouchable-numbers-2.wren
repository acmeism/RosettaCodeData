import "./math" for Int, Nums
import "./fmt" for Fmt

var limit = 1e6
var m = 63
var c = Int.primeSieve(limit, false)
var n = m * limit + 1
var sumDivs = List.filled(n, 0)
for (i in 1...n) {
    var j = i
    while (j < n) {
        sumDivs[j] = sumDivs[j] + i
        j = j + i
    }
}
var s = List.filled(n, false)
for (i in 1...n) {
    var sum = sumDivs[i] - i // proper divs sum
    if (sum <= n) s[sum] = true
}
var untouchable = [2, 5]
n = 6
while (n <= limit) {
    if (!s[n] && c[n-1] && c[n-3]) untouchable.add(n)
    n = n + 2
}
System.print("List of untouchable numbers <= 2,000:")
Fmt.tprint("$,6d", untouchable.where { |n| n <= 2000 }, 10)
System.print()
Fmt.print("$,7d untouchable numbers were found  <=     2,000", untouchable.count { |n| n <= 2000 })
var p = 10
var count = 0
for (n in untouchable) {
    count = count + 1
    if (n > p) {
        Fmt.print("$,7d untouchable numbers were found  <= $,9d", count-1, p)
        p = p * 10
        if (p == limit) break
    }
}
Fmt.print("$,7d untouchable numbers were found  <= $,d", untouchable.count, limit)
