import "./math" for Nums
import "./fmt" for Fmt

// recursively permutates the list of squares to seek a matching sum
var soms
soms = Fn.new { |n, f|
    if (n <= 0) return false
    if (f.contains(n)) return true
    var sum = Nums.sum(f)
    if (n > sum) return false
    if (n == sum) return true
    var rf = f[-1..0].skip(1).toList
    return soms.call(n - f[-1], rf) || soms.call(n, rf)
}

var start = System.clock
var s = []
var a = []
var sf = "\nStopped checking after finding $d sequential non-gaps after the final gap of $d"
var i = 1
var g = 1
var r
while (g >= (i >> 1)) {
    if ((r = i.sqrt.floor) * r == i) s.add(i)
    if (!soms.call(i, s)) a.add(g = i)
    i = i + 1
}
System.print("Numbers which are not the sum of distinct squares:")
System.print(a.join(", "))
Fmt.print(sf, i - g, g)
Fmt.print("Found $d total in $d ms.", a.count, ((System.clock - start)*1000).round)
