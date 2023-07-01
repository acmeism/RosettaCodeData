import "/math" for Int
import "/fmt" for Fmt

var sbs = [1, 1]

var sternBrocot = Fn.new { |n, fromStart|
    if (n < 4 || (n % 2 != 0)) Fiber.abort("n must be >= 4 and even.")
    var consider = fromStart ? 1 : (n/2).floor - 1
    while (true) {
        var sum = sbs[consider] + sbs[consider - 1]
        sbs.add(sum)
        sbs.add(sbs[consider])
        if (sbs.count == n) return
        consider = consider + 1
    }
}

var n = 16  // needs to be even to ensure 'considered' number is added
System.print("First 15 members of the Stern-Brocot sequence:")
sternBrocot.call(n, true)
System.print(sbs.take(15).toList)

var firstFind = List.filled(11, 0)
firstFind[0] = -1 // needs to be non-zero for subsequent test
var i = 0
for (v in sbs) {
    if (v <= 10 && firstFind[v] == 0) firstFind[v] = i + 1
    i = i + 1
}
while (true) {
    n = n + 2
    sternBrocot.call(n, false)
    var vv = sbs[-2..-1]
    var m = n - 1
    var outer = false
    for (v in vv) {
        if (v <= 10 && firstFind[v] == 0) firstFind[v] = m
        if (firstFind.all { |e| e != 0 }) {
            outer = true
            break
        }
        m = m + 1
    }
    if (outer) break
}
System.print("\nThe numbers 1 to 10 first appear at the following indices:")
for (i in 1..10) Fmt.print("$2d -> $d", i, firstFind[i])

System.write("\n100 first appears at index ")
while (true) {
    n = n + 2
    sternBrocot.call(n, false)
    var vv = sbs[-2..-1]
    if (vv[0] == 100) {
        System.print("%(n - 1).")
        break
    }
    if (vv[1] == 100) {
        System.print("%(n).")
        break
    }
}

System.write("\nThe GCDs of each pair of the series up to the 1,000th member are ")
var p = 0
while (p < 1000) {
    if (Int.gcd(sbs[p], sbs[p + 1]) != 1) {
        System.print("not all one.")
        return
    }
    p = p + 2
}
System.print("all one.")
