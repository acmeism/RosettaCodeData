import "./psieve" for Primes
import "./math" for Int
import "./fmt" for Fmt

var limit = 1e10
var gapStarts = {}
var it = Primes.iter()
var pc = Primes.count(2, limit * 5)
var p1 = it.next
var p2 = it.next
for (i in 1...pc) {
    var gap = p2 - p1
    if (!gapStarts[gap]) gapStarts[gap] = p1
    p1 = p2
    p2 = it.next
}
var pm = 10
var gap1 = 2
while (true) {
    while (!gapStarts[gap1]) gap1 = gap1 + 2
    var start1 = gapStarts[gap1]
    var gap2 = gap1 + 2
    if (!gapStarts[gap2]) {
        gap1 = gap2 + 2
        continue
    }
    var start2 = gapStarts[gap2]
    var diff = (start2 - start1).abs
    if (diff > pm) {
        Fmt.print("Earliest difference > $,d between adjacent prime gap starting primes:", pm)
        Fmt.print("Gap $d starts at $,d, gap $d starts at $,d, difference is $,d.\n", gap1, start1, gap2, start2, diff)
        if (pm == limit) break
        pm = pm * 10
    } else {
        gap1 = gap2
    }
}
